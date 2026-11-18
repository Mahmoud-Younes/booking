import 'package:booking/core/data/firestore_paths.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/features/search/data/models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Room-details I/O boundary: one-shot reads (quota guardrail) and the
/// deterministic-ID night multi-get that validates the requested window.
class RoomDetailsRepo {
  RoomDetailsRepo(this._db, this._paths);

  final FirebaseFirestore _db;
  final FirestorePaths _paths;

  /// One-shot room load — the load-from-ID path for shared/refreshed links.
  Future<Room?> getRoom(String roomId) async {
    final DocumentSnapshot<Room> snapshot = await _db
        .collection(_paths.rooms())
        .withRoomConverter()
        .doc(roomId)
        .get();
    return snapshot.data();
  }

  /// Availability for the requested window: a deterministic-ID read per
  /// night; any existing document means that night is taken. Bounded by the
  /// 30-night maximum.
  Future<bool> areNightsFree(String roomId, StayDateRange stayRange) async {
    for (final StayDate night in stayRange.occupiedNights()) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
          .doc(_paths.nightDoc(roomId, night.epochDay))
          .get();
      if (snapshot.exists) {
        return false;
      }
    }
    return true;
  }
}
