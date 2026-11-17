import 'package:booking/core/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';

/// Human-readable booking record.
///
/// Dates travel as UTC `Timestamp` plus the numeric epoch-day keys the
/// rules check; `createdAt` is the server clock. Serialization is
/// hand-written (not codegen) because the CREATE map must carry
/// `FieldValue.serverTimestamp()`, which json_serializable cannot express.
@freezed
sealed class Booking with _$Booking {
  const factory Booking({
    @Default('') String id,
    required String userId,
    required String roomId,
    required Timestamp checkIn,
    required Timestamp checkOut,
    required int checkInEpochDay,
    required int checkOutEpochDay,
    Timestamp? createdAt,
    @Default(Booking.statusActive) String status,
    @Default(Constants.policyVersion) int policyVersion,
    @Default(Constants.schemaVersion) int schemaVersion,
  }) = _Booking;

  factory Booking.fromMap(Map<String, dynamic> map, {String id = ''}) =>
      Booking(
        id: id,
        userId: map['userId'] as String? ?? '',
        roomId: map['roomId'] as String? ?? '',
        checkIn: map['checkIn'] as Timestamp? ?? Timestamp.fromMillisecondsSinceEpoch(0),
        checkOut: map['checkOut'] as Timestamp? ?? Timestamp.fromMillisecondsSinceEpoch(0),
        checkInEpochDay: map['checkInEpochDay'] as int? ?? 0,
        checkOutEpochDay: map['checkOutEpochDay'] as int? ?? 0,
        createdAt: map['createdAt'] as Timestamp?,
        status: map['status'] as String? ?? Booking.statusActive,
        policyVersion: map['policyVersion'] as int? ?? Constants.policyVersion,
        schemaVersion: map['schemaVersion'] as int? ?? Constants.schemaVersion,
      );

  const Booking._();

  static const String statusActive = 'active';
  static const String statusCancelled = 'cancelled';

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userId': userId,
        'roomId': roomId,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'checkInEpochDay': checkInEpochDay,
        'checkOutEpochDay': checkOutEpochDay,
        'createdAt': createdAt,
        'status': status,
        'policyVersion': policyVersion,
        'schemaVersion': schemaVersion,
      };

  /// The CREATE payload — server clock, never the client's.
  Map<String, dynamic> createMap() {
    final Map<String, dynamic> map = toMap();
    map['createdAt'] = FieldValue.serverTimestamp();
    return map;
  }
}

/// `withConverter` for the bookings collection (ID from `snap.id`).
extension BookingCollectionConverter on CollectionReference<Map<String, dynamic>> {
  CollectionReference<Booking> withBookingConverter() => withConverter<Booking>(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snap, _) =>
            Booking.fromMap(snap.data() ?? <String, dynamic>{}, id: snap.id),
        toFirestore: (Booking booking, _) {
          final Map<String, dynamic> json = booking.toMap()..remove('id');
          return json;
        },
      );
}
