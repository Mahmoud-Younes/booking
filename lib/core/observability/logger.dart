import 'package:flutter/foundation.dart';

/// One structured-logging format for both platforms.
///
/// In debug builds everything prints; in release builds info lines are
/// dropped and only errors surface (release web logging goes to the browser
/// console, Android errors additionally reach Crashlytics).
void logInfo(String message) {
  if (kDebugMode) {
    debugPrint('[INFO] $message');
  }
}

void logError(String message, [Object? error, StackTrace? stackTrace]) {
  debugPrint('[ERROR] $message'
      '${error != null ? ' | $error' : ''}'
      '${stackTrace != null ? '\n$stackTrace' : ''}');
}
