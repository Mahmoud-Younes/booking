// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchState()';
}


}

/// @nodoc
class $SearchStateCopyWith<$Res>  {
$SearchStateCopyWith(SearchState _, $Res Function(SearchState) __);
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Connecting value)?  connecting,TResult Function( Live value)?  live,TResult Function( EmptySearch value)?  empty,TResult Function( SearchFailed value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Connecting() when connecting != null:
return connecting(_that);case Live() when live != null:
return live(_that);case EmptySearch() when empty != null:
return empty(_that);case SearchFailed() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Connecting value)  connecting,required TResult Function( Live value)  live,required TResult Function( EmptySearch value)  empty,required TResult Function( SearchFailed value)  failure,}){
final _that = this;
switch (_that) {
case Connecting():
return connecting(_that);case Live():
return live(_that);case EmptySearch():
return empty(_that);case SearchFailed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Connecting value)?  connecting,TResult? Function( Live value)?  live,TResult? Function( EmptySearch value)?  empty,TResult? Function( SearchFailed value)?  failure,}){
final _that = this;
switch (_that) {
case Connecting() when connecting != null:
return connecting(_that);case Live() when live != null:
return live(_that);case EmptySearch() when empty != null:
return empty(_that);case SearchFailed() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  connecting,TResult Function( List<Room> rooms)?  live,TResult Function()?  empty,TResult Function( List<Room> lastRooms,  BookingFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Connecting() when connecting != null:
return connecting();case Live() when live != null:
return live(_that.rooms);case EmptySearch() when empty != null:
return empty();case SearchFailed() when failure != null:
return failure(_that.lastRooms,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  connecting,required TResult Function( List<Room> rooms)  live,required TResult Function()  empty,required TResult Function( List<Room> lastRooms,  BookingFailure failure)  failure,}) {final _that = this;
switch (_that) {
case Connecting():
return connecting();case Live():
return live(_that.rooms);case EmptySearch():
return empty();case SearchFailed():
return failure(_that.lastRooms,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  connecting,TResult? Function( List<Room> rooms)?  live,TResult? Function()?  empty,TResult? Function( List<Room> lastRooms,  BookingFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case Connecting() when connecting != null:
return connecting();case Live() when live != null:
return live(_that.rooms);case EmptySearch() when empty != null:
return empty();case SearchFailed() when failure != null:
return failure(_that.lastRooms,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class Connecting implements SearchState {
  const Connecting();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Connecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchState.connecting()';
}


}




/// @nodoc


class Live implements SearchState {
  const Live( List<Room> rooms): _rooms = rooms;
  

 final  List<Room> _rooms;
 List<Room> get rooms {
  if (_rooms is EqualUnmodifiableListView) return _rooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rooms);
}


/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveCopyWith<Live> get copyWith => _$LiveCopyWithImpl<Live>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Live&&const DeepCollectionEquality().equals(other.rooms, _rooms));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_rooms));
}

@override
String toString() {
    return 'SearchState.live(rooms: $rooms)';
}


}

/// @nodoc
abstract mixin class $LiveCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $LiveCopyWith(Live value, $Res Function(Live) _then) = _$LiveCopyWithImpl;
@useResult
$Res call({
 List<Room> rooms
});




}
/// @nodoc
class _$LiveCopyWithImpl<$Res>
    implements $LiveCopyWith<$Res> {
  _$LiveCopyWithImpl(this._self, this._then);

  final Live _self;
  final $Res Function(Live) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rooms = null,}) {
  return _then(Live(
null == rooms ? _self._rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<Room>,
  ));
}


}

/// @nodoc


class EmptySearch implements SearchState {
  const EmptySearch();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptySearch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SearchState.empty()';
}


}




/// @nodoc


class SearchFailed implements SearchState {
  const SearchFailed( List<Room> lastRooms, this.failure): _lastRooms = lastRooms;
  

 final  List<Room> _lastRooms;
 List<Room> get lastRooms {
  if (_lastRooms is EqualUnmodifiableListView) return _lastRooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lastRooms);
}

 final  BookingFailure failure;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFailedCopyWith<SearchFailed> get copyWith => _$SearchFailedCopyWithImpl<SearchFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFailed&&const DeepCollectionEquality().equals(other.lastRooms, _lastRooms)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_lastRooms),failure);
}

@override
String toString() {
    return 'SearchState.failure(lastRooms: $lastRooms, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SearchFailedCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchFailedCopyWith(SearchFailed value, $Res Function(SearchFailed) _then) = _$SearchFailedCopyWithImpl;
@useResult
$Res call({
 List<Room> lastRooms, BookingFailure failure
});




}
/// @nodoc
class _$SearchFailedCopyWithImpl<$Res>
    implements $SearchFailedCopyWith<$Res> {
  _$SearchFailedCopyWithImpl(this._self, this._then);

  final SearchFailed _self;
  final $Res Function(SearchFailed) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lastRooms = null,Object? failure = null,}) {
  return _then(SearchFailed(
null == lastRooms ? _self._lastRooms : lastRooms // ignore: cast_nullable_to_non_nullable
as List<Room>,null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as BookingFailure,
  ));
}


}

// dart format on
