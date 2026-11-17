// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignUpRequestBody {

 String get name; String get email; String get password;
/// Create a copy of SignUpRequestBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpRequestBodyCopyWith<SignUpRequestBody> get copyWith => _$SignUpRequestBodyCopyWithImpl<SignUpRequestBody>(this as SignUpRequestBody, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SignUpRequestBody;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpRequestBody&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.password, _this.password) || other.password == _this.password));
}


@override
int get hashCode {
  final _this = this as SignUpRequestBody;
  return Object.hash(runtimeType,_this.name,_this.email,_this.password);
}

@override
String toString() {
  final _this = this as SignUpRequestBody;
  return 'SignUpRequestBody(name: ${_this.name}, email: ${_this.email}, password: ${_this.password})';
}


}

/// @nodoc
abstract mixin class $SignUpRequestBodyCopyWith<$Res>  {
  factory $SignUpRequestBodyCopyWith(SignUpRequestBody value, $Res Function(SignUpRequestBody) _then) = _$SignUpRequestBodyCopyWithImpl;
@useResult
$Res call({
 String name, String email, String password
});




}
/// @nodoc
class _$SignUpRequestBodyCopyWithImpl<$Res>
    implements $SignUpRequestBodyCopyWith<$Res> {
  _$SignUpRequestBodyCopyWithImpl(this._self, this._then);

  final SignUpRequestBody _self;
  final $Res Function(SignUpRequestBody) _then;

/// Create a copy of SignUpRequestBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? password = null,}) {
  return _then(SignUpRequestBody(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SignUpRequestBody].
extension SignUpRequestBodyPatterns on SignUpRequestBody {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignUpRequestBody value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignUpRequestBody() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignUpRequestBody value)  $default,){
final _that = this;
switch (_that) {
case _SignUpRequestBody():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignUpRequestBody value)?  $default,){
final _that = this;
switch (_that) {
case _SignUpRequestBody() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String email,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignUpRequestBody() when $default != null:
return $default(_that.name,_that.email,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String email,  String password)  $default,) {final _that = this;
switch (_that) {
case _SignUpRequestBody():
return $default(_that.name,_that.email,_that.password);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String email,  String password)?  $default,) {final _that = this;
switch (_that) {
case _SignUpRequestBody() when $default != null:
return $default(_that.name,_that.email,_that.password);case _:
  return null;

}
}

}

/// @nodoc


class _SignUpRequestBody implements SignUpRequestBody {
  const _SignUpRequestBody({required this.name, required this.email, required this.password});
  

@override final  String name;
@override final  String email;
@override final  String password;

/// Create a copy of SignUpRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignUpRequestBodyCopyWith<_SignUpRequestBody> get copyWith => __$SignUpRequestBodyCopyWithImpl<_SignUpRequestBody>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignUpRequestBody&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,email,password);
}

@override
String toString() {
    return 'SignUpRequestBody(name: $name, email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$SignUpRequestBodyCopyWith<$Res> implements $SignUpRequestBodyCopyWith<$Res> {
  factory _$SignUpRequestBodyCopyWith(_SignUpRequestBody value, $Res Function(_SignUpRequestBody) _then) = __$SignUpRequestBodyCopyWithImpl;
@override @useResult
$Res call({
 String name, String email, String password
});




}
/// @nodoc
class __$SignUpRequestBodyCopyWithImpl<$Res>
    implements _$SignUpRequestBodyCopyWith<$Res> {
  __$SignUpRequestBodyCopyWithImpl(this._self, this._then);

  final _SignUpRequestBody _self;
  final $Res Function(_SignUpRequestBody) _then;

/// Create a copy of SignUpRequestBody
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? password = null,}) {
  return _then(_SignUpRequestBody(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
