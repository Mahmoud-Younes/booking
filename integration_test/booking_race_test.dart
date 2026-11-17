// The CORE-REQUIREMENT GATE (G1): two CONCURRENT bookings for the same room
// with overlapping dates must produce exactly one commit and one
// conflictLost — proven against the Firestore emulator.
//
// Run (Firestore emulator must be up):
//   firebase emulators:start --only firestore,auth
//   flutter test integration_test/booking_race_test.dart -d <android-emulator>
//
// Contention realism (per review M-8.1): the two racing attempts run on TWO
// INDEPENDENT FirebaseApp instances with separately authenticated users, so
// the test exercises the true contention path, not sequential validation.
// Android emulator networking: `10.0.2.2` reaches the host's Firestore
// emulator (the classic localhost trap).
import 'package:booking/core/data/firestore_paths.dart';
import 'package:booking/core/env/env.dart';
import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/error/result.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/features/booking/data/models/booking.dart';
import 'package:booking/features/booking/data/repos/booking_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

const String kProjectId = 'sahety-ba784';

Future<FirebaseApp> _initApp(String name) async {
  final FirebaseApp app = await Firebase.initializeApp(
    name: name,
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FirebaseFirestore db = FirebaseFirestore.instanceFor(app: app);
  db.useFirestoreEmulator('10.0.2.2', 8080);
  final FirebaseAuth auth = FirebaseAuth.instanceFor(app: app);
  await auth.useAuthEmulator('10.0.2.2', 9099);
  return app;
}

void main() {
  late FirebaseApp appA;
  late FirebaseApp appB;
  late BookingRepo repoA;
  late BookingRepo repoB;
  const String roomId = 'race_room_01';

  setUpAll(() async {
    appA = await _initApp('raceA');
    appB = await _initApp('raceB');
    // Anonymous sign-ins on each app: rules require an authenticated user
    // for night creates, and each attempt carries its own userId.
    await FirebaseAuth.instanceFor(app: appA).signInAnonymously();
    await FirebaseAuth.instanceFor(app: appB).signInAnonymously();
    repoA = BookingRepo(
        FirebaseFirestore.instanceFor(app: appA), const FirestorePaths(Env.prod));
    repoB = BookingRepo(
        FirebaseFirestore.instanceFor(app: appB), const FirestorePaths(Env.prod));
    // Stash the uids for the test bodies via expects below.
    // (Both repos sign in anonymously; rules require auth for night creates.)
  });

  testWidgets('two concurrent overlapping bookings -> exactly one winner',
      (WidgetTester tester) async {
    // PRECONDITION: the room catalog is seeded against the emulator first
    // (rules make rooms client-read-only):
    //   FIRESTORE_EMULATOR_HOST=localhost:8080 node tool/seed/seed.mjs
    StayDateRange stay() => StayDateRange(
          checkIn: StayDate.parse('2027-01-01'),
          checkOut: StayDate.parse('2027-01-03'),
        );

    // Fire BOTH attempts truly concurrently and collect the outcomes.
    final List<Result<Booking>> outcomes = await Future.wait(<Future<Result<Booking>>>[
      repoA.attemptBooking(userId: 'race_a', roomId: roomId, stayRange: stay()),
      repoB.attemptBooking(userId: 'race_b', roomId: roomId, stayRange: stay()),
    ]);

    final int successes =
        outcomes.whereType<Success<Booking>>().length;
    final int conflicts = outcomes
        .whereType<Failure<Booking>>()
        .where((Failure<Booking> failure) =>
            failure.failure.code == FailureCode.conflictLost)
        .length;

    expect(successes, 1,
        reason: 'exactly one booking may commit for overlapping nights');
    expect(conflicts, 1, reason: 'the loser must surface conflictLost');
    expect(successes + conflicts, 2);

    final QuerySnapshot<Map<String, dynamic>> nights = await FirebaseFirestore
        .instanceFor(app: appA)
        .collection('rooms/$roomId/nights')
        .get();
    expect(nights.docs.length, 2,
        reason: 'only the winner wrote the 2 night documents');
  });

  testWidgets('freed nights are re-bookable after cancellation',
      (WidgetTester tester) async {
    StayDateRange stay() => StayDateRange(
          checkIn: StayDate.parse('2027-02-01'),
          checkOut: StayDate.parse('2027-02-02'),
        );

    final Result<Booking> booked = await repoA.attemptBooking(
      userId: 'race_a',
      roomId: roomId,
      stayRange: stay(),
    );
    expect(booked, isA<Success<Booking>>());

    final Result<Booking> cancelled =
        await repoA.cancelBooking((booked as Success<Booking>).data);
    expect(cancelled, isA<Success<Booking>>());

    final Result<Booking> rebooked = await repoB.attemptBooking(
      userId: 'race_b',
      roomId: roomId,
      stayRange: stay(),
    );
    expect(rebooked, isA<Success<Booking>>(),
        reason: 'freed nights must be bookable again');
  });
}
