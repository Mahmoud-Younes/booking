import 'package:booking/core/helpers/stay_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StayDate normalization', () {
    test('normalizes any local DateTime to its UTC calendar day', () {
      // 2026-12-01 23:30 UTC+2 local == 2026-12-01 21:30 UTC -> same day.
      final StayDate date = StayDate.fromDateTime(
        DateTime.parse('2026-12-01T23:30+02:00'),
      );
      expect(date.value, '2026-12-01');
    });

    test('rolls a local pre-midnight instant into the previous UTC day', () {
      // 2026-12-02 00:30 at UTC+2 == 2026-12-01 22:30 UTC.
      final StayDate date = StayDate.fromDateTime(
        DateTime.parse('2026-12-02T00:30+02:00'),
      );
      expect(date.value, '2026-12-01');
    });

    test('epoch-day round trip is exact', () {
      final StayDate date = StayDate.parse('2027-06-15');
      expect(StayDate.fromEpochDay(date.epochDay).value, '2027-06-15');
    });

    test('rejects malformed strings', () {
      expect(() => StayDate.parse('2026/12/01'), throwsFormatException);
      expect(() => StayDate.parse('01-12-2026'), throwsFormatException);
    });

    test('equality is by calendar day, not object identity', () {
      expect(
        StayDate.parse('2026-12-01'),
        StayDate.fromDateTime(DateTime.parse('2026-12-01T12:00Z')),
      );
    });
  });

  group('StayDateRange (half-open [checkIn, checkOut))', () {
    late StayDateRange range;

    setUp(() {
      range = StayDateRange(
        checkIn: StayDate.parse('2026-12-01'),
        checkOut: StayDate.parse('2026-12-04'),
      );
    });

    test('nights counts the half-open length', () {
      expect(range.nights, 3);
    });

    test('contains check-in but not check-out day', () {
      expect(range.contains(StayDate.parse('2026-12-01')), isTrue);
      expect(range.contains(StayDate.parse('2026-12-03')), isTrue);
      expect(range.contains(StayDate.parse('2026-12-04')), isFalse);
    });

    test('adjacent ranges share no night (checkout day stays sellable)', () {
      final StayDateRange next = StayDateRange(
        checkIn: StayDate.parse('2026-12-04'),
        checkOut: StayDate.parse('2026-12-06'),
      );
      final List<StayDate> shared = range
          .occupiedNights()
          .where(next.contains)
          .toList();
      expect(shared, isEmpty);
    });

    test('nights enumerates exactly the occupied nights', () {
      expect(
        range.occupiedNights().map((StayDate d) => d.value).toList(),
        ['2026-12-01', '2026-12-02', '2026-12-03'],
      );
    });

    test('rejects inverted or zero-night ranges', () {
      expect(
        () => StayDateRange(
          checkIn: StayDate.parse('2026-12-04'),
          checkOut: StayDate.parse('2026-12-04'),
        ),
        throwsArgumentError,
      );
      expect(
        () => StayDateRange(
          checkIn: StayDate.parse('2026-12-05'),
          checkOut: StayDate.parse('2026-12-04'),
        ),
        throwsArgumentError,
      );
    });

    test('flags a stay beyond the pinned 30-night maximum', () {
      final StayDateRange long = StayDateRange(
        checkIn: StayDate.parse('2026-12-01'),
        checkOut: StayDate.parse('2027-01-05'),
      );
      expect(long.nights, greaterThan(maxStayNights));
      expect(long.exceedsMaxStay, isTrue);
      expect(range.exceedsMaxStay, isFalse);
    });
  });

  group('nightsUntil', () {
    test('is positive for later days and negative for earlier ones', () {
      final StayDate a = StayDate.parse('2026-12-01');
      final StayDate b = StayDate.parse('2026-12-10');
      expect(a.nightsUntil(b), 9);
      expect(b.nightsUntil(a), -9);
      expect(a.nightsUntil(a), 0);
    });
  });
}
