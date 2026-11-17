import 'package:booking/core/env/env.dart';

/// The single owner of every Firestore path in the app.
///
/// The dev collection prefix is applied here and nowhere else: a missed
/// prefix requires bypassing this class. Repos receive this object through
/// their constructor (never `FirebaseFirestore.instance` directly) so tests
/// can point them at the emulator.
class FirestorePaths {
  const FirestorePaths(this._env);

  final Env _env;

  String get _prefix => _env.collectionPrefix;

  // Rooms catalog and per-night availability documents.
  String rooms() => '${_prefix}rooms';
  String roomNights(String roomId) => '${rooms()}/$roomId/nights';
  String nightDoc(String roomId, int epochDay) => '${roomNights(roomId)}/$epochDay';

  // Human-readable booking records and the failure audit trail.
  String bookings() => '${_prefix}bookings';
  String bookingDoc(String bookingId) => '${bookings()}/$bookingId';
  String bookingFailures() => '${_prefix}booking_failures';

  // User profile documents.
  String users() => '${_prefix}users';
  String userDoc(String uid) => '${users()}/$uid';
}
