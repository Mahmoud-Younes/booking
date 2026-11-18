import 'package:booking/core/data/firestore_paths.dart';
import 'package:booking/core/helpers/constants.dart';
import 'package:booking/features/search/data/models/room.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Search I/O boundary. Cold streams only — NEVER calls `.listen`; the
/// SearchCubit owns the subscription lifecycle.
class SearchRepo {
  SearchRepo(this._db, this._paths);

  final FirebaseFirestore _db;
  final FirestorePaths _paths;

  /// Live results stream. Server-side predicates (Firestore compound-query
  /// constraint: range field == orderBy field): `city ==` + optional
  /// `pricePerNight <=` range, ordered by price, windowed by limit().
  /// The guests filter (`capacity >=`) is applied client-side in the cubit.
  Stream<List<Room>> watchRooms(SearchQuery query) {
    Query<Room> roomsQuery = _db
        .collection(_paths.rooms())
        .withRoomConverter()
        .where('city', isEqualTo: query.city)
        .orderBy('pricePerNight', descending: query.sortDescending);
    if (query.maxPrice != null) {
      roomsQuery = roomsQuery.where('pricePerNight',
          isLessThanOrEqualTo: query.maxPrice);
    }
    return roomsQuery
        .limit(Constants.resultsLimit)
        .snapshots()
        .map((QuerySnapshot<Room> snapshot) =>
            snapshot.docs.map((DocumentSnapshot<Room> doc) => doc.data()!).toList());
  }

  /// One-shot read for detail screens (load-from-ID path: survives refresh
  /// and shared links on web).
  Future<Room?> getRoom(String roomId) async {
    final DocumentSnapshot<Room> snapshot = await _db
        .collection(_paths.rooms())
        .withRoomConverter()
        .doc(roomId)
        .get();
    return snapshot.data();
  }
}
