/// Shared constants — limits and document schema versions.
class Constants {
  Constants._();

  /// Pinned stay policy: maximum nights per booking (mirrored in rules).
  static const int maxStayNights = 30;

  /// Results query page size (every listener is query-scoped with limit).
  static const int resultsLimit = 50;

  /// Date policy version stamped on every booking document (half-open
  /// [checkIn, checkOut), UTC normalization).
  static const int policyVersion = 1;

  /// Additive-only schema evolution marker on every document.
  static const int schemaVersion = 1;

  /// Web breakpoint for the page shell.
  static const double webMaxContentWidth = 720;
}
