import 'package:flutter/material.dart';

/// Navigation extensions (doc_doc pattern) — named routes only.
extension NavigationExtension on BuildContext {
  void pushNamed(String routeName, {Object? arguments}) =>
      pushNamedAndRemoveUntil(routeName, arguments: arguments, predicate: (route) => true);

  void pushReplacementNamed(String routeName, {Object? arguments}) =>
      Navigator.pushReplacementNamed(this, routeName, arguments: arguments);

  void pushNamedAndRemoveUntil(
    String routeName, {
    required RoutePredicate predicate,
    Object? arguments,
  }) =>
      Navigator.pushNamedAndRemoveUntil(
        this,
        routeName,
        predicate,
        arguments: arguments,
      );

  void pop() => Navigator.pop(this);
}

/// Null-safe list/map helpers.
extension NullableListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}

extension NullableMapExtension<K, V> on Map<K, V>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}
