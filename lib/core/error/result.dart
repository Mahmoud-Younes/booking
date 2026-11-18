import 'package:booking/core/error/failure_code.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// A success/failure envelope for Firestore actions: every action repo method
/// returns a [Result] and the cubit unwraps it with `when`.
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;

  const factory Result.failure(BookingFailure failure) = Failure<T>;
}
