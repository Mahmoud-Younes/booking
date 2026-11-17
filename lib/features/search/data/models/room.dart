import 'package:booking/core/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

/// A rentable room in the catalog — the single denormalized collection
/// (no separate hotels collection, per the decided Alternative F).
///
/// The document ID is injected by the converter from `snap.id`, never from
/// the map: three UI contracts (stable list keys, in-place updates, details
/// routing) depend on it.
@freezed
sealed class Room with _$Room {
  const factory Room({
    @Default('') String id,
    required String city,
    required String title,
    required num pricePerNight,
    required int capacity,
    required String imageUrl,
    @Default(Constants.schemaVersion) int schemaVersion,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}

/// `withConverter` extension — the map shape exists in exactly one place and
/// repos never touch raw maps.
extension RoomCollectionConverter on CollectionReference<Map<String, dynamic>> {
  CollectionReference<Room> withRoomConverter() => withConverter<Room>(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snap, _) =>
            Room.fromJson(<String, dynamic>{...snap.data() ?? <String, dynamic>{}, 'id': snap.id}),
        toFirestore: (Room room, _) {
          // The ID lives on the document path, not in the fields.
          final Map<String, dynamic> json = room.toJson()..remove('id');
          return json;
        },
      );
}
