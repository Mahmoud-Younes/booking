// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_failure_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingFailureRecord {

 String get id; String? get userId; String get roomId; String get checkIn; String get checkOut; String get code; String get rawCode; Timestamp? get createdAt;
/// Create a copy of BookingFailureRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingFailureRecordCopyWith<BookingFailureRecord> get copyWith => _$BookingFailureRecordCopyWithImpl<BookingFailureRecord>(this as BookingFailureRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BookingFailureRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingFailureRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.roomId, _this.roomId) || other.roomId == _this.roomId)&&(identical(other.checkIn, _this.checkIn) || other.checkIn == _this.checkIn)&&(identical(other.checkOut, _this.checkOut) || other.checkOut == _this.checkOut)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.rawCode, _this.rawCode) || other.rawCode == _this.rawCode)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as BookingFailureRecord;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.roomId,_this.checkIn,_this.checkOut,_this.code,_this.rawCode,_this.createdAt);
}

@override
String toString() {
  final _this = this as BookingFailureRecord;
  return 'BookingFailureRecord(id: ${_this.id}, userId: ${_this.userId}, roomId: ${_this.roomId}, checkIn: ${_this.checkIn}, checkOut: ${_this.checkOut}, code: ${_this.code}, rawCode: ${_this.rawCode}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $BookingFailureRecordCopyWith<$Res>  {
  factory $BookingFailureRecordCopyWith(BookingFailureRecord value, $Res Function(BookingFailureRecord) _then) = _$BookingFailureRecordCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, String roomId, String checkIn, String checkOut, String code, String rawCode, Timestamp? createdAt
});




}
/// @nodoc
class _$BookingFailureRecordCopyWithImpl<$Res>
    implements $BookingFailureRecordCopyWith<$Res> {
  _$BookingFailureRecordCopyWithImpl(this._self, this._then);

  final BookingFailureRecord _self;
  final $Res Function(BookingFailureRecord) _then;

/// Create a copy of BookingFailureRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? roomId = null,Object? checkIn = null,Object? checkOut = null,Object? code = null,Object? rawCode = null,Object? createdAt = freezed,}) {
  return _then(BookingFailureRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,rawCode: null == rawCode ? _self.rawCode : rawCode // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingFailureRecord].
extension BookingFailureRecordPatterns on BookingFailureRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingFailureRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingFailureRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingFailureRecord value)  $default,){
final _that = this;
switch (_that) {
case _BookingFailureRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingFailureRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BookingFailureRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userId,  String roomId,  String checkIn,  String checkOut,  String code,  String rawCode,  Timestamp? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingFailureRecord() when $default != null:
return $default(_that.id,_that.userId,_that.roomId,_that.checkIn,_that.checkOut,_that.code,_that.rawCode,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userId,  String roomId,  String checkIn,  String checkOut,  String code,  String rawCode,  Timestamp? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BookingFailureRecord():
return $default(_that.id,_that.userId,_that.roomId,_that.checkIn,_that.checkOut,_that.code,_that.rawCode,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userId,  String roomId,  String checkIn,  String checkOut,  String code,  String rawCode,  Timestamp? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BookingFailureRecord() when $default != null:
return $default(_that.id,_that.userId,_that.roomId,_that.checkIn,_that.checkOut,_that.code,_that.rawCode,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _BookingFailureRecord implements BookingFailureRecord {
  const _BookingFailureRecord({this.id = '', this.userId, required this.roomId, required this.checkIn, required this.checkOut, required this.code, this.rawCode = '', this.createdAt});
  

@override@JsonKey() final  String id;
@override final  String? userId;
@override final  String roomId;
@override final  String checkIn;
@override final  String checkOut;
@override final  String code;
@override@JsonKey() final  String rawCode;
@override final  Timestamp? createdAt;

/// Create a copy of BookingFailureRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingFailureRecordCopyWith<_BookingFailureRecord> get copyWith => __$BookingFailureRecordCopyWithImpl<_BookingFailureRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingFailureRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.code, code) || other.code == code)&&(identical(other.rawCode, rawCode) || other.rawCode == rawCode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,roomId,checkIn,checkOut,code,rawCode,createdAt);
}

@override
String toString() {
    return 'BookingFailureRecord(id: $id, userId: $userId, roomId: $roomId, checkIn: $checkIn, checkOut: $checkOut, code: $code, rawCode: $rawCode, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BookingFailureRecordCopyWith<$Res> implements $BookingFailureRecordCopyWith<$Res> {
  factory _$BookingFailureRecordCopyWith(_BookingFailureRecord value, $Res Function(_BookingFailureRecord) _then) = __$BookingFailureRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userId, String roomId, String checkIn, String checkOut, String code, String rawCode, Timestamp? createdAt
});




}
/// @nodoc
class __$BookingFailureRecordCopyWithImpl<$Res>
    implements _$BookingFailureRecordCopyWith<$Res> {
  __$BookingFailureRecordCopyWithImpl(this._self, this._then);

  final _BookingFailureRecord _self;
  final $Res Function(_BookingFailureRecord) _then;

/// Create a copy of BookingFailureRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? roomId = null,Object? checkIn = null,Object? checkOut = null,Object? code = null,Object? rawCode = null,Object? createdAt = freezed,}) {
  return _then(_BookingFailureRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,rawCode: null == rawCode ? _self.rawCode : rawCode // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}


}

// dart format on
