// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_bookings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyBookingsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MyBookingsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MyBookingsState()';
}


}

/// @nodoc
class $MyBookingsStateCopyWith<$Res>  {
$MyBookingsStateCopyWith(MyBookingsState _, $Res Function(MyBookingsState) __);
}


/// Adds pattern-matching-related methods to [MyBookingsState].
extension MyBookingsStatePatterns on MyBookingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BookingsConnecting value)?  connecting,TResult Function( BookingsLive value)?  live,TResult Function( BookingsEmpty value)?  empty,TResult Function( BookingsFailed value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BookingsConnecting() when connecting != null:
return connecting(_that);case BookingsLive() when live != null:
return live(_that);case BookingsEmpty() when empty != null:
return empty(_that);case BookingsFailed() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BookingsConnecting value)  connecting,required TResult Function( BookingsLive value)  live,required TResult Function( BookingsEmpty value)  empty,required TResult Function( BookingsFailed value)  failure,}){
final _that = this;
switch (_that) {
case BookingsConnecting():
return connecting(_that);case BookingsLive():
return live(_that);case BookingsEmpty():
return empty(_that);case BookingsFailed():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BookingsConnecting value)?  connecting,TResult? Function( BookingsLive value)?  live,TResult? Function( BookingsEmpty value)?  empty,TResult? Function( BookingsFailed value)?  failure,}){
final _that = this;
switch (_that) {
case BookingsConnecting() when connecting != null:
return connecting(_that);case BookingsLive() when live != null:
return live(_that);case BookingsEmpty() when empty != null:
return empty(_that);case BookingsFailed() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  connecting,TResult Function( List<Booking> bookings)?  live,TResult Function()?  empty,TResult Function( List<Booking> lastBookings,  BookingFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BookingsConnecting() when connecting != null:
return connecting();case BookingsLive() when live != null:
return live(_that.bookings);case BookingsEmpty() when empty != null:
return empty();case BookingsFailed() when failure != null:
return failure(_that.lastBookings,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  connecting,required TResult Function( List<Booking> bookings)  live,required TResult Function()  empty,required TResult Function( List<Booking> lastBookings,  BookingFailure failure)  failure,}) {final _that = this;
switch (_that) {
case BookingsConnecting():
return connecting();case BookingsLive():
return live(_that.bookings);case BookingsEmpty():
return empty();case BookingsFailed():
return failure(_that.lastBookings,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  connecting,TResult? Function( List<Booking> bookings)?  live,TResult? Function()?  empty,TResult? Function( List<Booking> lastBookings,  BookingFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case BookingsConnecting() when connecting != null:
return connecting();case BookingsLive() when live != null:
return live(_that.bookings);case BookingsEmpty() when empty != null:
return empty();case BookingsFailed() when failure != null:
return failure(_that.lastBookings,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class BookingsConnecting implements MyBookingsState {
  const BookingsConnecting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingsConnecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MyBookingsState.connecting()';
}


}




/// @nodoc


class BookingsLive implements MyBookingsState {
  const BookingsLive( List<Booking> bookings): _bookings = bookings;
  

 final  List<Booking> _bookings;
 List<Booking> get bookings {
  if (_bookings is EqualUnmodifiableListView) return _bookings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookings);
}


/// Create a copy of MyBookingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingsLiveCopyWith<BookingsLive> get copyWith => _$BookingsLiveCopyWithImpl<BookingsLive>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingsLive&&const DeepCollectionEquality().equals(other.bookings, _bookings));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_bookings));
}

@override
String toString() {
    return 'MyBookingsState.live(bookings: $bookings)';
}


}

/// @nodoc
abstract mixin class $BookingsLiveCopyWith<$Res> implements $MyBookingsStateCopyWith<$Res> {
  factory $BookingsLiveCopyWith(BookingsLive value, $Res Function(BookingsLive) _then) = _$BookingsLiveCopyWithImpl;
@useResult
$Res call({
 List<Booking> bookings
});




}
/// @nodoc
class _$BookingsLiveCopyWithImpl<$Res>
    implements $BookingsLiveCopyWith<$Res> {
  _$BookingsLiveCopyWithImpl(this._self, this._then);

  final BookingsLive _self;
  final $Res Function(BookingsLive) _then;

/// Create a copy of MyBookingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? bookings = null,}) {
  return _then(BookingsLive(
null == bookings ? _self._bookings : bookings // ignore: cast_nullable_to_non_nullable
as List<Booking>,
  ));
}


}

/// @nodoc


class BookingsEmpty implements MyBookingsState {
  const BookingsEmpty();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingsEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MyBookingsState.empty()';
}


}




/// @nodoc


class BookingsFailed implements MyBookingsState {
  const BookingsFailed( List<Booking> lastBookings, this.failure): _lastBookings = lastBookings;
  

 final  List<Booking> _lastBookings;
 List<Booking> get lastBookings {
  if (_lastBookings is EqualUnmodifiableListView) return _lastBookings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lastBookings);
}

 final  BookingFailure failure;

/// Create a copy of MyBookingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingsFailedCopyWith<BookingsFailed> get copyWith => _$BookingsFailedCopyWithImpl<BookingsFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingsFailed&&const DeepCollectionEquality().equals(other.lastBookings, _lastBookings)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_lastBookings),failure);
}

@override
String toString() {
    return 'MyBookingsState.failure(lastBookings: $lastBookings, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $BookingsFailedCopyWith<$Res> implements $MyBookingsStateCopyWith<$Res> {
  factory $BookingsFailedCopyWith(BookingsFailed value, $Res Function(BookingsFailed) _then) = _$BookingsFailedCopyWithImpl;
@useResult
$Res call({
 List<Booking> lastBookings, BookingFailure failure
});




}
/// @nodoc
class _$BookingsFailedCopyWithImpl<$Res>
    implements $BookingsFailedCopyWith<$Res> {
  _$BookingsFailedCopyWithImpl(this._self, this._then);

  final BookingsFailed _self;
  final $Res Function(BookingsFailed) _then;

/// Create a copy of MyBookingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lastBookings = null,Object? failure = null,}) {
  return _then(BookingsFailed(
null == lastBookings ? _self._lastBookings : lastBookings // ignore: cast_nullable_to_non_nullable
as List<Booking>,null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as BookingFailure,
  ));
}


}

// dart format on
