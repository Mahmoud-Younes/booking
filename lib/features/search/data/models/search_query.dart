import 'package:booking/core/helpers/stay_date.dart';

/// The one search value object — parsed from the results route URL on web so
/// refresh and shared links reproduce the same results.
///
/// Server-side predicates (Firestore compound-query constraint: the range
/// field must equal the orderBy field): `city ==` equality, `pricePerNight
/// <= maxPrice` range, ordered by `pricePerNight`. The guest-count filter
/// (`capacity >= guests`) is applied client-side inside the fetched window.
class SearchQuery {
  const SearchQuery({
    required this.city,
    required this.stayRange,
    required this.guests,
    this.maxPrice,
    this.sortDescending = false,
  });

  final String city;
  final StayDateRange stayRange;
  final int guests;
  final num? maxPrice;
  final bool sortDescending;
}
