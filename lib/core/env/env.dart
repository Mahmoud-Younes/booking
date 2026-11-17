/// Build-time environment selected by the flavor entry points.
///
/// Carries everything that differs between development and production so no
/// other layer needs to know which flavor it is running in.
class Env {
  const Env._({
    required this.collectionPrefix,
    required this.enableCrashlytics,
    required this.isDev,
  });

  /// Development flavor: writes into `dev_`-prefixed collections, no crash
  /// reporting, verbose logging.
  static const Env dev = Env._(
    collectionPrefix: 'dev_',
    enableCrashlytics: false,
    isDev: true,
  );

  /// Production flavor: unprefixed collections, Crashlytics on Android.
  static const Env prod = Env._(
    collectionPrefix: '',
    enableCrashlytics: true,
    isDev: false,
  );

  /// Collection-name prefix. Applied exactly once, by FirestorePaths — a
  /// missed prefix requires bypassing that class.
  final String collectionPrefix;

  /// Crashlytics is wired on Android only (Flutter Web has no support; the
  /// gap is an accepted, documented decision).
  final bool enableCrashlytics;

  final bool isDev;
}
