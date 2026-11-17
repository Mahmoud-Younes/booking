import 'package:booking/core/routing/routes.dart';
import 'package:flutter/material.dart';

/// Named-route generator (doc_doc pattern: a switch over route names).
///
/// Feature routes are registered here as their feature branches land; every
/// route will receive one typed argument class, cast once, and every
/// URL-reachable route must survive a null argument by loading from IDs.
class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
      case Routes.homeScreen:
        return _materialRoute(settings, _PlaceholderScreen(routeName: settings.name ?? ''));
      default:
        return null;
    }
  }

  MaterialPageRoute<dynamic> _materialRoute(RouteSettings settings, Widget screen) =>
      MaterialPageRoute<dynamic>(settings: settings, builder: (_) => screen);
}

/// Temporary stand-in screen shown until its feature branch lands.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: Center(child: Text('Under construction: $routeName')),
    );
  }
}
