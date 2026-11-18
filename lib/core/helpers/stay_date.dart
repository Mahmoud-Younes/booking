/// Pure date utilities for the stay contract — zero Flutter or Firebase
/// imports, fully unit-testable.
///
/// This class IS the project's date contract: nights are half-open
/// `[checkIn, checkOut)`, normalized to UTC, so a given calendar night has
/// exactly one representation everywhere (path keys, comparisons, picker
/// bounds). Never store, compare, or derive dates any other way.
library;

/// A UTC calendar day, carried as its `yyyy-MM-dd` string and its integer
/// epoch day (days since the Unix epoch, UTC).
class StayDate {
  StayDate._(this.value, this.epochDay);

  /// Night key: `yyyy-MM-dd`, always UTC-normalized.
  final String value;

  /// Days since the Unix epoch (UTC) — the numeric night key used in
  /// availability document paths and rule checks.
  final int epochDay;

  static final DateTime _epoch = DateTime.utc(1970, 1, 1);

  /// Normalizes any [dateTime] (local or UTC) to its UTC calendar day.
  factory StayDate.fromDateTime(DateTime dateTime) {
    final DateTime utc = dateTime.toUtc();
    final DateTime day = DateTime.utc(utc.year, utc.month, utc.day);
    return StayDate._(_format(day), day.difference(_epoch).inDays);
  }

  /// Builds from the numeric night key.
  factory StayDate.fromEpochDay(int epochDay) {
    final DateTime day = _epoch.add(Duration(days: epochDay));
    return StayDate._(_format(day), epochDay);
  }

  /// Today's UTC calendar day — the single wall-clock entry point.
  factory StayDate.todayUtc() => StayDate.fromDateTime(DateTime.now());

  /// Parses `yyyy-MM-dd`.
  factory StayDate.parse(String value) {
    final RegExp pattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!pattern.hasMatch(value)) {
      throw FormatException('StayDate must be yyyy-MM-dd, got: $value');
    }
    final List<String> parts = value.split('-');
    final DateTime day = DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    return StayDate._(value, day.difference(_epoch).inDays);
  }

  static String _format(DateTime day) {
    final String month = day.month.toString().padLeft(2, '0');
    final String dayOfMonth = day.day.toString().padLeft(2, '0');
    return '${day.year}-$month-$dayOfMonth';
  }

  /// Days from this night to [other] (positive when [other] is later).
  int nightsUntil(StayDate other) => other.epochDay - epochDay;

  /// Display string `d/M/yyyy` — the one display format in the UI.
  String get display {
    final DateTime day = _epoch.add(Duration(days: epochDay));
    return '${day.day}/${day.month}/${day.year}';
  }

  @override
  bool operator ==(Object other) => other is StayDate && other.epochDay == epochDay;

  @override
  int get hashCode => epochDay.hashCode;

  @override
  String toString() => value;
}

/// A stay `[checkIn, checkOut)` — the check-out day is NOT occupied and
/// stays sellable (half-open policy, pinned in the design).
class StayDateRange {
  StayDateRange({
    required this.checkIn,
    required this.checkOut,
  }) {
    if (checkOut.epochDay <= checkIn.epochDay) {
      throw ArgumentError('checkOut must be at least one night after checkIn');
    }
  }

  final StayDate checkIn;
  final StayDate checkOut;

  /// Number of occupied nights (half-open range length).
  int get nights => checkIn.nightsUntil(checkOut);

  /// True when the stay violates the pinned 30-night maximum.
  bool get exceedsMaxStay => nights > maxStayNights;

  /// Every occupied night in `[checkIn, checkOut)` — the write set of a
  /// booking transaction.
  List<StayDate> occupiedNights() => List<StayDate>.generate(
        nights,
        (int i) => StayDate.fromEpochDay(checkIn.epochDay + i),
      );

  /// True when [date] falls inside this stay (half-open).
  bool contains(StayDate date) =>
      date.epochDay >= checkIn.epochDay && date.epochDay < checkOut.epochDay;

  @override
  String toString() => '${checkIn.value} → ${checkOut.value}';
}

/// Pinned stay policy: maximum nights per booking (also enforced by the
/// booking rules via the epoch-day delta).
const int maxStayNights = 30;
