import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:firebase_core/firebase_core.dart';

/// The single place where raw Firebase errors are interpreted.
///
/// Mapping table (behavior-defining — the offline-pending contract fires on
/// [FailureCode.networkUnavailable]):
/// - `unavailable`, `network-request-failed`, `deadline-exceeded`
///     -> networkUnavailable
/// - `permission-denied` -> ruleDenied
/// - `unauthenticated`, auth flow codes -> authRequired
/// - [BookingConflictException] (typed abort inside the transaction)
///     -> conflictLost
/// - anything else -> unknown (raw code preserved)
class FirebaseErrorMapper {
  FirebaseErrorMapper._();

  static FailureCode map(Object error) {
    if (error is BookingConflictException) {
      return FailureCode.conflictLost;
    }
    if (error is FirebaseException) {
      return switch (error.code) {
        'unavailable' ||
        'network-request-failed' ||
        'deadline-exceeded' =>
          FailureCode.networkUnavailable,
        'permission-denied' => FailureCode.ruleDenied,
        'unauthenticated' ||
        'user-not-found' ||
        'wrong-password' ||
        'invalid-email' ||
        'email-already-in-use' ||
        'weak-password' ||
        'user-disabled' ||
        'too-many-requests' =>
          FailureCode.authRequired,
        _ => FailureCode.unknown,
      };
    }
    return FailureCode.unknown;
  }

  /// Arabic user-facing message for a typed failure (no raw Firebase text).
  static String message(BookingFailure failure) => switch (failure.code) {
        FailureCode.authRequired => AppStrings.errorAuthRequired,
        FailureCode.networkUnavailable => AppStrings.errorNetworkUnavailable,
        FailureCode.ruleDenied => AppStrings.errorRuleDenied,
        FailureCode.conflictLost => AppStrings.errorConflictLost,
        FailureCode.transactionRetryExhausted => AppStrings.errorTransactionRetry,
        FailureCode.unknown => AppStrings.errorUnknown,
      };
}
