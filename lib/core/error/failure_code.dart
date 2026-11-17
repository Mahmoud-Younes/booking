/// Typed failure taxonomy for every Firebase-facing operation.
///
/// Raw Firebase codes are always preserved alongside the typed code so the
/// console audit trail stays debuggable.
enum FailureCode {
  /// No session, wrong credentials, or a required-auth gap.
  authRequired,

  /// Connectivity problem (offline, timeout, network failure).
  networkUnavailable,

  /// Firestore security rules rejected the operation.
  ruleDenied,

  /// Lost a booking race: someone else committed the same night first.
  conflictLost,

  /// The transaction exhausted its retries without a definitive outcome.
  transactionRetryExhausted,

  /// Anything else (raw code kept for diagnostics).
  unknown,
}

/// A typed failure carried through Result — raw Firebase strings never reach
/// the UI (the mapper converts [FailureCode] to one Arabic message).
class BookingFailure {
  const BookingFailure({required this.code, this.rawCode});

  final FailureCode code;
  final String? rawCode;

  @override
  String toString() => 'BookingFailure(${code.name}, raw: $rawCode)';
}

/// Thrown INSIDE a booking transaction to abort it when a requested night is
/// already taken. The repo catches it and maps it to [FailureCode.conflictLost]
/// — the deterministic-ID collision is how a lost race is detected.
class BookingConflictException implements Exception {
  const BookingConflictException(this.nightValue);

  final String nightValue;

  @override
  String toString() => 'BookingConflictException($nightValue)';
}
