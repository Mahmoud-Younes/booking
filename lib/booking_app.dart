import 'package:booking/core/routing/app_router.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/widgets/breakpoint_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Application widget: Arabic-only RTL UI, ScreenUtil sizing against a
/// 375x812 design, named routing, and the web breakpoint shell.
///
/// The start route comes from the FIRST authStateChanges emission, awaited
/// in the entry points — a stream cannot supply a one-time initial route.
class BookingApp extends StatelessWidget {
  const BookingApp({super.key, required this.startRoute});

  /// Routes.loginScreen when signed out, Routes.homeScreen when signed in.
  final String startRoute;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        title: 'Booking',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorsManager.mainBlue,
          scaffoldBackgroundColor: ColorsManager.white,
          colorScheme: ColorScheme.fromSeed(seedColor: ColorsManager.mainBlue),
        ),
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: startRoute,
        onGenerateRoute: AppRouter().generateRoute,
        builder: (context, child) =>
            BreakpointShell(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
