import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/features/auth/ui/screens/login_screen.dart';
import 'package:booking/features/auth/ui/screens/sign_up_screen.dart';
import 'package:booking/core/error/failure_code.dart';
import 'package:booking/features/booking/ui/screens/booking_confirm_screen.dart';
import 'package:booking/features/booking/ui/screens/conflict_screen.dart';
import 'package:booking/features/booking/ui/screens/my_bookings_screen.dart';
import 'package:booking/features/room_details/ui/screens/room_details_screen.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:booking/features/search/ui/screens/home_screen.dart';
import 'package:booking/features/search/ui/screens/results_screen.dart';
import 'package:booking/features/search/ui/widgets/results_list.dart';
import 'package:flutter/material.dart';

/// Named-route generator (doc_doc pattern, extended for web).
///
/// Every route casts ONE typed argument class once. URL-reachable routes
/// (results, details) survive a null/malformed argument: the results route
/// parses its search parameters from the URL query string (path strategy +
/// SPA rewrite), and falls back to the search form when anything is off.
class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return _materialRoute(settings, const LoginScreen());
      case Routes.signUpScreen:
        return _materialRoute(settings, const SignUpScreen());
      case Routes.homeScreen:
        return _materialRoute(settings, const HomeScreen());
      case Routes.resultsScreen:
        final SearchQuery? query = _resultsQuery(settings.arguments, settings.name);
        return _materialRoute(
          settings,
          query == null
              ? const HomeScreen()
              : ResultsScreen(query: query),
        );
      case Routes.roomDetailsScreen:
        final Object? arguments = settings.arguments;
        if (arguments is RoomDetailsArgs) {
          return _materialRoute(settings, RoomDetailsScreen(args: arguments));
        }
        return _materialRoute(settings, const HomeScreen());
      case Routes.bookingConfirmScreen:
        final Object? arguments = settings.arguments;
        if (arguments is ConfirmBookingArgs) {
          return _materialRoute(settings, BookingConfirmScreen(args: arguments));
        }
        return _materialRoute(settings, const HomeScreen());
      case Routes.conflictScreen:
        final Object? arguments = settings.arguments;
        if (arguments is BookingFailure && arguments.code == FailureCode.conflictLost) {
          return _materialRoute(settings, ConflictScreen(failure: arguments));
        }
        return _materialRoute(settings, const HomeScreen());
      case Routes.myBookingsScreen:
        return _materialRoute(settings, const MyBookingsScreen());
      default:
        return null;
    }
  }

  /// Results arguments come from in-app navigation (typed [SearchQuery]) OR
  /// from a shared/refreshed URL (`?city=..&in=..&out=..&guests=..&max=..&sort=..`).
  SearchQuery? _resultsQuery(Object? arguments, String? name) {
    if (arguments is SearchQuery) {
      return arguments;
    }
    final String? raw = name;
    if (raw == null || !raw.contains('?')) {
      return null;
    }
    try {
      final Map<String, String> params = Uri.parse(raw).queryParameters;
      final StayDate checkIn = StayDate.parse(params['in'] ?? '');
      final StayDate checkOut = StayDate.parse(params['out'] ?? '');
      final int guests = int.parse(params['guests'] ?? '0');
      if (guests < 1) {
        return null;
      }
      return SearchQuery(
        city: params['city'] ?? '',
        stayRange: StayDateRange(checkIn: checkIn, checkOut: checkOut),
        guests: guests,
        maxPrice: params['max'] == null ? null : num.tryParse(params['max']!),
        sortDescending: params['sort'] == 'desc',
      );
    } on FormatException {
      return null;
    } on ArgumentError {
      return null;
    }
  }

  MaterialPageRoute<dynamic> _materialRoute(RouteSettings settings, Widget screen) =>
      MaterialPageRoute<dynamic>(settings: settings, builder: (_) => screen);
}
