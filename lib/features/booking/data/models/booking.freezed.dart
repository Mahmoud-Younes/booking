// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Booking {

 String get id; String get userId; String get roomId; Timestamp get checkIn; Timestamp get checkOut; int get checkInEpochDay; int get checkOutEpochDay; Timestamp? get createdAt; String get status; int get policyVersion; int get schemaVersion;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Booking;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.roomId, _this.roomId) || other.roomId == _this.roomId)&&(identical(other.checkIn, _this.checkIn) || other.checkIn == _this.checkIn)&&(identical(other.checkOut, _this.checkOut) || other.checkOut == _this.checkOut)&&(identical(other.checkInEpochDay, _this.checkInEpochDay) || other.checkInEpochDay == _this.checkInEpochDay)&&(identical(other.checkOutEpochDay, _this.checkOutEpochDay) || other.checkOutEpochDay == _this.checkOutEpochDay)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.policyVersion, _this.policyVersion) || other.policyVersion == _this.policyVersion)&&(identical(other.schemaVersion, _this.schemaVersion) || other.schemaVersion == _this.schemaVersion));
}


@override
int get hashCode {
  final _this = this as Booking;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.roomId,_this.checkIn,_this.checkOut,_this.checkInEpochDay,_this.checkOutEpochDay,_this.createdAt,_this.status,_this.policyVersion,_this.schemaVersion);
}

@override
String toString() {
  final _this = this as Booking;
  return 'Booking(id: ${_this.id}, userId: ${_this.userId}, roomId: ${_this.roomId}, checkIn: ${_this.checkIn}, checkOut: ${_this.checkOut}, checkInEpochDay: ${_this.checkInEpochDay}, checkOutEpochDay: ${_this.checkOutEpochDay}, createdAt: ${_this.createdAt}, status: ${_this.status}, policyVersion: ${_this.policyVersion}, schemaVersion: ${_this.schemaVersion})';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String roomId, Timestamp checkIn, Timestamp checkOut, int checkInEpochDay, int checkOutEpochDay, Timestamp? createdAt, String status, int policyVersion, int schemaVersion
});




}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? roomId = null,Object? checkIn = null,Object? checkOut = null,Object? checkInEpochDay = null,Object? checkOutEpochDay = null,Object? createdAt = freezed,Object? status = null,Object? policyVersion = null,Object? schemaVersion = null,}) {
  return _then(Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as Timestamp,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as Timestamp,checkInEpochDay: null == checkInEpochDay ? _self.checkInEpochDay : checkInEpochDay // ignore: cast_nullable_to_non_nullable
as int,checkOutEpochDay: null == checkOutEpochDay ? _self.checkOutEpochDay : checkOutEpochDay // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as int,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String roomId,  Timestamp checkIn,  Timestamp checkOut,  int checkInEpochDay,  int checkOutEpochDay,  Timestamp? createdAt,  String status,  int policyVersion,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.userId,_that.roomId,_that.checkIn,_that.checkOut,_that.checkInEpochDay,_that.checkOutEpochDay,_that.createdAt,_that.status,_that.policyVersion,_that.schemaVersion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String roomId,  Timestamp checkIn,  Timestamp checkOut,  int checkInEpochDay,  int checkOutEpochDay,  Timestamp? createdAt,  String status,  int policyVersion,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.userId,_that.roomId,_that.checkIn,_that.checkOut,_that.checkInEpochDay,_that.checkOutEpochDay,_that.createdAt,_that.status,_that.policyVersion,_that.schemaVersion);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String roomId,  Timestamp checkIn,  Timestamp checkOut,  int checkInEpochDay,  int checkOutEpochDay,  Timestamp? createdAt,  String status,  int policyVersion,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.userId,_that.roomId,_that.checkIn,_that.checkOut,_that.checkInEpochDay,_that.checkOutEpochDay,_that.createdAt,_that.status,_that.policyVersion,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc


class _Booking extends Booking {
  const _Booking({this.id = '', required this.userId, required this.roomId, required this.checkIn, required this.checkOut, required this.checkInEpochDay, required this.checkOutEpochDay, this.createdAt, this.status = Booking.statusActive, this.policyVersion = Constants.policyVersion, this.schemaVersion = Constants.schemaVersion}): super._();
  

@override@JsonKey() final  String id;
@override final  String userId;
@override final  String roomId;
@override final  Timestamp checkIn;
@override final  Timestamp checkOut;
@override final  int checkInEpochDay;
@override final  int checkOutEpochDay;
@override final  Timestamp? createdAt;
@override@JsonKey() final  String status;
@override@JsonKey() final  int policyVersion;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.checkInEpochDay, checkInEpochDay) || other.checkInEpochDay == checkInEpochDay)&&(identical(other.checkOutEpochDay, checkOutEpochDay) || other.checkOutEpochDay == checkOutEpochDay)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,roomId,checkIn,checkOut,checkInEpochDay,checkOutEpochDay,createdAt,status,policyVersion,schemaVersion);
}

@override
String toString() {
    return 'Booking(id: $id, userId: $userId, roomId: $roomId, checkIn: $checkIn, checkOut: $checkOut, checkInEpochDay: $checkInEpochDay, checkOutEpochDay: $checkOutEpochDay, createdAt: $createdAt, status: $status, policyVersion: $policyVersion, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String roomId, Timestamp checkIn, Timestamp checkOut, int checkInEpochDay, int checkOutEpochDay, Timestamp? createdAt, String status, int policyVersion, int schemaVersion
});




}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? roomId = null,Object? checkIn = null,Object? checkOut = null,Object? checkInEpochDay = null,Object? checkOutEpochDay = null,Object? createdAt = freezed,Object? status = null,Object? policyVersion = null,Object? schemaVersion = null,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as Timestamp,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as Timestamp,checkInEpochDay: null == checkInEpochDay ? _self.checkInEpochDay : checkInEpochDay // ignore: cast_nullable_to_non_nullable
as int,checkOutEpochDay: null == checkOutEpochDay ? _self.checkOutEpochDay : checkOutEpochDay // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as int,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
