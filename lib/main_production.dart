import 'dart:io';

import 'package:booking/booking_app.dart';
import 'package:booking/core/di/dependency_injection.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/env/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:booking/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

/// Production flavor entry point: unprefixed collections, Crashlytics on
/// Android, path-based web URLs.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Path-based web URLs (SPA rewrite is configured in firebase.json).
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  const Env env = Env.prod;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupGetIt(env);
  await ScreenUtil.ensureScreenSize();
  _wireCrashReporting(env);
  // Await the FIRST authStateChanges emission: a stream cannot supply a
  // one-time initial route.
  final User? initialUser = await getIt<FirebaseAuth>().authStateChanges().first;
  runApp(BookingApp(startRoute: initialUser != null ? Routes.homeScreen : Routes.loginScreen));
}

/// Crashlytics is wired on Android only; the Flutter Web gap is an accepted,
/// documented decision.
void _wireCrashReporting(Env env) {
  if (kIsWeb || !Platform.isAndroid || !env.enableCrashlytics) {
    return;
  }
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
