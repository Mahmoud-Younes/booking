// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
  id: json['id'] as String? ?? '',
  city: json['city'] as String,
  title: json['title'] as String,
  pricePerNight: json['pricePerNight'] as num,
  capacity: (json['capacity'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  schemaVersion:
      (json['schemaVersion'] as num?)?.toInt() ?? Constants.schemaVersion,
);

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'id': instance.id,
  'city': instance.city,
  'title': instance.title,
  'pricePerNight': instance.pricePerNight,
  'capacity': instance.capacity,
  'imageUrl': instance.imageUrl,
  'schemaVersion': instance.schemaVersion,
};
