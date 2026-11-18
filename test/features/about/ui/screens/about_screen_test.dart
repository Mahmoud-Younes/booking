import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/features/about/ui/screens/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget test: the About screen must alone answer "what is this app and
/// what does it do" for any reviewer — technical or not.
void main() {
  testWidgets('About screen states the identity, the core guarantee, and the stack',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      // Same shape as BookingApp: ScreenUtil sizing + Arabic RTL delegates.
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (BuildContext context, Widget? child) => MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const AboutScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Identity.
    expect(find.text(AppStrings.aboutTitle), findsOneWidget);
    expect(find.text(AppStrings.aboutAppName), findsOneWidget);
    expect(find.byIcon(Icons.hotel), findsOneWidget);

    // The two questions the screen exists to answer.
    expect(find.text(AppStrings.aboutWhatTitle), findsOneWidget);
    expect(find.text(AppStrings.aboutGuaranteeTitle), findsOneWidget);
    expect(find.textContaining('لا حجز مزدوج'), findsWidgets,
        reason: 'the no-double-booking guarantee is stated verbatim');

    // Server-side enforcement and its proof are named, not implied.
    expect(find.textContaining('معاملة Firestore'), findsOneWidget);
    expect(find.textContaining('اختبار سباق'), findsOneWidget);

    // Stack + reviewer pointers + footer.
    expect(find.textContaining('Flutter'), findsWidgets);
    expect(find.textContaining('docs/designs/'), findsOneWidget);
    expect(find.textContaining('DEPI'), findsOneWidget);
  });
}
