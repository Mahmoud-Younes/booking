import 'package:booking/core/data/firestore_paths.dart';
import 'package:booking/core/env/env.dart';
import 'package:booking/features/auth/data/repos/auth_repo.dart';
import 'package:booking/features/auth/logic/cubit/login_cubit.dart';
import 'package:booking/features/auth/logic/cubit/sign_up_cubit.dart';
import 'package:booking/features/booking/data/repos/booking_repo.dart';
import 'package:booking/features/booking/logic/cubit/booking_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

/// Global service locator (doc_doc pattern: get_it, manual registration).
final getIt = GetIt.instance;

/// Registers every service for the selected [env].
///
/// Called from the flavor entry points before runApp: repos as
/// lazySingletons, screen-bound cubits strictly as factories (a factory per
/// route pop keeps stream subscriptions screen-scoped).
void setupGetIt(Env env) {
  // Core singletons.
  getIt.registerLazySingleton<Env>(() => env);
  getIt.registerLazySingleton<FirestorePaths>(() => FirestorePaths(getIt()));
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Auth.
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt(), getIt(), getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerFactory<SignUpCubit>(() => SignUpCubit(getIt()));

  // Booking engine.
  getIt.registerLazySingleton<BookingRepo>(() => BookingRepo(getIt(), getIt()));
  getIt.registerFactory<BookingCubit>(() => BookingCubit(getIt()));
}
