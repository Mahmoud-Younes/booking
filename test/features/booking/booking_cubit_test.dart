import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/error/result.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/features/booking/data/models/booking.dart';
import 'package:booking/features/booking/data/repos/booking_repo.dart';
import 'package:booking/features/booking/logic/cubit/booking_cubit.dart';
import 'package:booking/features/booking/logic/cubit/booking_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockBookingRepo extends Mock implements BookingRepo {}

StayDateRange _stay() => StayDateRange(
      checkIn: StayDate.parse('2026-12-01'),
      checkOut: StayDate.parse('2026-12-03'),
    );

void main() {
  setUpAll(() {
    registerFallbackValue(_stay());
    registerFallbackValue(Booking(
      id: 'b0',
      userId: 'u0',
      roomId: 'r0',
      checkIn: Timestamp.fromMillisecondsSinceEpoch(0),
      checkOut: Timestamp.fromMillisecondsSinceEpoch(1),
      checkInEpochDay: 0,
      checkOutEpochDay: 1,
    ));
  });

  late _MockBookingRepo repo;

  setUp(() {
    repo = _MockBookingRepo();
    when(() => repo.attemptBooking(
          userId: any(named: 'userId'),
          roomId: any(named: 'roomId'),
          stayRange: any(named: 'stayRange'),
        )).thenAnswer((_) async => const Result.failure(
        BookingFailure(code: FailureCode.unknown, rawCode: 'unused')));
  });

  BookingCubit buildCubit() => BookingCubit(repo);

  blocTest<BookingCubit, BookingState>(
    'submit: [submitting, success] on a committed booking',
    build: () {
      when(() => repo.attemptBooking(
            userId: 'user_a',
            roomId: 'room_1',
            stayRange: any(named: 'stayRange'),
          )).thenAnswer((_) async => Result.success(Booking(
            id: 'b1',
            userId: 'user_a',
            roomId: 'room_1',
            checkIn: Timestamp.fromMillisecondsSinceEpoch(0),
            checkOut: Timestamp.fromMillisecondsSinceEpoch(1),
            checkInEpochDay: 1,
            checkOutEpochDay: 2,
          )));
      return buildCubit();
    },
    act: (BookingCubit cubit) => cubit.submit(
      userId: 'user_a',
      roomId: 'room_1',
      stayRange: _stay(),
    ),
    expect: () => <dynamic>[
      isA<Submitting>(),
      isA<BookingSuccess>(),
    ],
  );

  blocTest<BookingCubit, BookingState>(
    'a lost race surfaces bookingFailure(conflictLost) — not a generic error',
    build: () {
      when(() => repo.attemptBooking(
            userId: 'user_a',
            roomId: 'room_1',
            stayRange: any(named: 'stayRange'),
          )).thenAnswer((_) async => const Result.failure(
          BookingFailure(code: FailureCode.conflictLost, rawCode: 'x')));
      return buildCubit();
    },
    act: (BookingCubit cubit) => cubit.submit(
      userId: 'user_a',
      roomId: 'room_1',
      stayRange: _stay(),
    ),
    expect: () => <dynamic>[
      isA<Submitting>(),
      isA<BookingFailed>().having(
        (BookingFailed s) => s.failure.code,
        'code',
        FailureCode.conflictLost,
      ),
    ],
  );

  blocTest<BookingCubit, BookingState>(
    'connectivity failure emits the honest offline-pending state',
    build: () {
      when(() => repo.attemptBooking(
            userId: 'user_a',
            roomId: 'room_1',
            stayRange: any(named: 'stayRange'),
          )).thenAnswer((_) async => const Result.failure(
          BookingFailure(code: FailureCode.networkUnavailable, rawCode: 'x')));
      return buildCubit();
    },
    act: (BookingCubit cubit) => cubit.submit(
      userId: 'user_a',
      roomId: 'room_1',
      stayRange: _stay(),
    ),
    expect: () => <dynamic>[
      isA<Submitting>(),
      isA<OfflinePending>(),
    ],
  );

  blocTest<BookingCubit, BookingState>(
    'cancel: [cancelling, cancelSuccess] and the state carries the cancelled booking',
    build: () {
      when(() => repo.cancelBooking(any())).thenAnswer((_) async =>
          Result.success(Booking(
            id: 'b1',
            userId: 'user_a',
            roomId: 'room_1',
            checkIn: Timestamp.fromMillisecondsSinceEpoch(0),
            checkOut: Timestamp.fromMillisecondsSinceEpoch(1),
            checkInEpochDay: 1,
            checkOutEpochDay: 2,
            status: Booking.statusCancelled,
          )));
      return buildCubit();
    },
    act: (BookingCubit cubit) => cubit.cancel(Booking(
      id: 'b1',
      userId: 'user_a',
      roomId: 'room_1',
      checkIn: Timestamp.fromMillisecondsSinceEpoch(0),
      checkOut: Timestamp.fromMillisecondsSinceEpoch(1),
      checkInEpochDay: 1,
      checkOutEpochDay: 2,
    )),
    expect: () => <dynamic>[
      isA<Cancelling>(),
      isA<CancelSuccess>(),
    ],
  );
}
