import 'package:booking/core/routing/app_router.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/widgets/breakpoint_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Application widget: Arabic-only RTL UI, ScreenUtil sizing against a
/// 375x812 design, named routing, and the web breakpoint shell.
class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

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
        // Switched to authStateChanges-driven routing when the auth feature
        // lands; until then the login placeholder is the entry route.
        initialRoute: Routes.loginScreen,
        onGenerateRoute: AppRouter().generateRoute,
        builder: (context, child) =>
            BreakpointShell(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
