// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BookingState()';
}


}

/// @nodoc
class $BookingStateCopyWith<$Res>  {
$BookingStateCopyWith(BookingState _, $Res Function(BookingState) __);
}


/// Adds pattern-matching-related methods to [BookingState].
extension BookingStatePatterns on BookingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Idle value)?  idle,TResult Function( Submitting value)?  submitting,TResult Function( OfflinePending value)?  offlinePending,TResult Function( BookingSuccess value)?  bookingSuccess,TResult Function( BookingFailed value)?  bookingFailure,TResult Function( Cancelling value)?  cancelling,TResult Function( CancelSuccess value)?  cancelSuccess,TResult Function( CancelFailed value)?  cancelFailure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case Submitting() when submitting != null:
return submitting(_that);case OfflinePending() when offlinePending != null:
return offlinePending(_that);case BookingSuccess() when bookingSuccess != null:
return bookingSuccess(_that);case BookingFailed() when bookingFailure != null:
return bookingFailure(_that);case Cancelling() when cancelling != null:
return cancelling(_that);case CancelSuccess() when cancelSuccess != null:
return cancelSuccess(_that);case CancelFailed() when cancelFailure != null:
return cancelFailure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Idle value)  idle,required TResult Function( Submitting value)  submitting,required TResult Function( OfflinePending value)  offlinePending,required TResult Function( BookingSuccess value)  bookingSuccess,required TResult Function( BookingFailed value)  bookingFailure,required TResult Function( Cancelling value)  cancelling,required TResult Function( CancelSuccess value)  cancelSuccess,required TResult Function( CancelFailed value)  cancelFailure,}){
final _that = this;
switch (_that) {
case _Idle():
return idle(_that);case Submitting():
return submitting(_that);case OfflinePending():
return offlinePending(_that);case BookingSuccess():
return bookingSuccess(_that);case BookingFailed():
return bookingFailure(_that);case Cancelling():
return cancelling(_that);case CancelSuccess():
return cancelSuccess(_that);case CancelFailed():
return cancelFailure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Idle value)?  idle,TResult? Function( Submitting value)?  submitting,TResult? Function( OfflinePending value)?  offlinePending,TResult? Function( BookingSuccess value)?  bookingSuccess,TResult? Function( BookingFailed value)?  bookingFailure,TResult? Function( Cancelling value)?  cancelling,TResult? Function( CancelSuccess value)?  cancelSuccess,TResult? Function( CancelFailed value)?  cancelFailure,}){
final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle(_that);case Submitting() when submitting != null:
return submitting(_that);case OfflinePending() when offlinePending != null:
return offlinePending(_that);case BookingSuccess() when bookingSuccess != null:
return bookingSuccess(_that);case BookingFailed() when bookingFailure != null:
return bookingFailure(_that);case Cancelling() when cancelling != null:
return cancelling(_that);case CancelSuccess() when cancelSuccess != null:
return cancelSuccess(_that);case CancelFailed() when cancelFailure != null:
return cancelFailure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function()?  offlinePending,TResult Function( Booking booking)?  bookingSuccess,TResult Function( BookingFailure failure)?  bookingFailure,TResult Function()?  cancelling,TResult Function( Booking booking)?  cancelSuccess,TResult Function( BookingFailure failure)?  cancelFailure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case Submitting() when submitting != null:
return submitting();case OfflinePending() when offlinePending != null:
return offlinePending();case BookingSuccess() when bookingSuccess != null:
return bookingSuccess(_that.booking);case BookingFailed() when bookingFailure != null:
return bookingFailure(_that.failure);case Cancelling() when cancelling != null:
return cancelling();case CancelSuccess() when cancelSuccess != null:
return cancelSuccess(_that.booking);case CancelFailed() when cancelFailure != null:
return cancelFailure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function()  offlinePending,required TResult Function( Booking booking)  bookingSuccess,required TResult Function( BookingFailure failure)  bookingFailure,required TResult Function()  cancelling,required TResult Function( Booking booking)  cancelSuccess,required TResult Function( BookingFailure failure)  cancelFailure,}) {final _that = this;
switch (_that) {
case _Idle():
return idle();case Submitting():
return submitting();case OfflinePending():
return offlinePending();case BookingSuccess():
return bookingSuccess(_that.booking);case BookingFailed():
return bookingFailure(_that.failure);case Cancelling():
return cancelling();case CancelSuccess():
return cancelSuccess(_that.booking);case CancelFailed():
return cancelFailure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function()?  offlinePending,TResult? Function( Booking booking)?  bookingSuccess,TResult? Function( BookingFailure failure)?  bookingFailure,TResult? Function()?  cancelling,TResult? Function( Booking booking)?  cancelSuccess,TResult? Function( BookingFailure failure)?  cancelFailure,}) {final _that = this;
switch (_that) {
case _Idle() when idle != null:
return idle();case Submitting() when submitting != null:
return submitting();case OfflinePending() when offlinePending != null:
return offlinePending();case BookingSuccess() when bookingSuccess != null:
return bookingSuccess(_that.booking);case BookingFailed() when bookingFailure != null:
return bookingFailure(_that.failure);case Cancelling() when cancelling != null:
return cancelling();case CancelSuccess() when cancelSuccess != null:
return cancelSuccess(_that.booking);case CancelFailed() when cancelFailure != null:
return cancelFailure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Idle implements BookingState {
  const _Idle();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Idle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BookingState.idle()';
}


}




/// @nodoc


class Submitting implements BookingState {
  const Submitting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Submitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BookingState.submitting()';
}


}




/// @nodoc


class OfflinePending implements BookingState {
  const OfflinePending();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflinePending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BookingState.offlinePending()';
}


}




/// @nodoc


class BookingSuccess implements BookingState {
  const BookingSuccess(this.booking);
  

 final  Booking booking;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingSuccessCopyWith<BookingSuccess> get copyWith => _$BookingSuccessCopyWithImpl<BookingSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingSuccess&&(identical(other.booking, booking) || other.booking == booking));
}


@override
int get hashCode {
    return Object.hash(runtimeType,booking);
}

@override
String toString() {
    return 'BookingState.bookingSuccess(booking: $booking)';
}


}

/// @nodoc
abstract mixin class $BookingSuccessCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory $BookingSuccessCopyWith(BookingSuccess value, $Res Function(BookingSuccess) _then) = _$BookingSuccessCopyWithImpl;
@useResult
$Res call({
 Booking booking
});


$BookingCopyWith<$Res> get booking;

}
/// @nodoc
class _$BookingSuccessCopyWithImpl<$Res>
    implements $BookingSuccessCopyWith<$Res> {
  _$BookingSuccessCopyWithImpl(this._self, this._then);

  final BookingSuccess _self;
  final $Res Function(BookingSuccess) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? booking = null,}) {
  return _then(BookingSuccess(
null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,
  ));
}

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}

/// @nodoc


class BookingFailed implements BookingState {
  const BookingFailed(this.failure);
  

 final  BookingFailure failure;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingFailedCopyWith<BookingFailed> get copyWith => _$BookingFailedCopyWithImpl<BookingFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'BookingState.bookingFailure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $BookingFailedCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory $BookingFailedCopyWith(BookingFailed value, $Res Function(BookingFailed) _then) = _$BookingFailedCopyWithImpl;
@useResult
$Res call({
 BookingFailure failure
});




}
/// @nodoc
class _$BookingFailedCopyWithImpl<$Res>
    implements $BookingFailedCopyWith<$Res> {
  _$BookingFailedCopyWithImpl(this._self, this._then);

  final BookingFailed _self;
  final $Res Function(BookingFailed) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(BookingFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as BookingFailure,
  ));
}


}

/// @nodoc


class Cancelling implements BookingState {
  const Cancelling();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Cancelling);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BookingState.cancelling()';
}


}




/// @nodoc


class CancelSuccess implements BookingState {
  const CancelSuccess(this.booking);
  

 final  Booking booking;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CancelSuccessCopyWith<CancelSuccess> get copyWith => _$CancelSuccessCopyWithImpl<CancelSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CancelSuccess&&(identical(other.booking, booking) || other.booking == booking));
}


@override
int get hashCode {
    return Object.hash(runtimeType,booking);
}

@override
String toString() {
    return 'BookingState.cancelSuccess(booking: $booking)';
}


}

/// @nodoc
abstract mixin class $CancelSuccessCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory $CancelSuccessCopyWith(CancelSuccess value, $Res Function(CancelSuccess) _then) = _$CancelSuccessCopyWithImpl;
@useResult
$Res call({
 Booking booking
});


$BookingCopyWith<$Res> get booking;

}
/// @nodoc
class _$CancelSuccessCopyWithImpl<$Res>
    implements $CancelSuccessCopyWith<$Res> {
  _$CancelSuccessCopyWithImpl(this._self, this._then);

  final CancelSuccess _self;
  final $Res Function(CancelSuccess) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? booking = null,}) {
  return _then(CancelSuccess(
null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as Booking,
  ));
}

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingCopyWith<$Res> get booking {
  
  return $BookingCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}

/// @nodoc


class CancelFailed implements BookingState {
  const CancelFailed(this.failure);
  

 final  BookingFailure failure;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CancelFailedCopyWith<CancelFailed> get copyWith => _$CancelFailedCopyWithImpl<CancelFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CancelFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'BookingState.cancelFailure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $CancelFailedCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory $CancelFailedCopyWith(CancelFailed value, $Res Function(CancelFailed) _then) = _$CancelFailedCopyWithImpl;
@useResult
$Res call({
 BookingFailure failure
});




}
/// @nodoc
class _$CancelFailedCopyWithImpl<$Res>
    implements $CancelFailedCopyWith<$Res> {
  _$CancelFailedCopyWithImpl(this._self, this._then);

  final CancelFailed _self;
  final $Res Function(CancelFailed) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(CancelFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as BookingFailure,
  ));
}


}

// dart format on
