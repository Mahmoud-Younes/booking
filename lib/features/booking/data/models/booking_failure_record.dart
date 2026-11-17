import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_failure_record.freezed.dart';

/// Best-effort diagnostics record written on every failed booking attempt.
///
/// This collection is NOT load-bearing for the core guarantee: the proof of
/// one-booking-per-night is the server-committed state itself (the winning
/// booking document + night documents). These records exist so a lost race
/// is reconstructible from the console — including the raw Firebase code.
@freezed
sealed class BookingFailureRecord with _$BookingFailureRecord {
  const factory BookingFailureRecord({
    @Default('') String id,
    String? userId,
    required String roomId,
    required String checkIn,
    required String checkOut,
    required String code,
    @Default('') String rawCode,
    Timestamp? createdAt,
  }) = _BookingFailureRecord;

  factory BookingFailureRecord.fromMap(Map<String, dynamic> map, {String id = ''}) =>
      BookingFailureRecord(
        id: id,
        userId: map['userId'] as String?,
        roomId: map['roomId'] as String? ?? '',
        checkIn: map['checkIn'] as String? ?? '',
        checkOut: map['checkOut'] as String? ?? '',
        code: map['code'] as String? ?? 'unknown',
        rawCode: map['rawCode'] as String? ?? '',
        createdAt: map['createdAt'] as Timestamp?,
      );
}
