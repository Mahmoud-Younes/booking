import 'package:booking/core/data/firestore_paths.dart';
import 'package:booking/core/env/env.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

/// Global service locator (doc_doc pattern: get_it, manual registration).
final getIt = GetIt.instance;

/// Registers every service for the selected [env].
///
/// Called from the flavor entry points before runApp. The platform handles
/// and core singletons are registered here; feature repos are registered as
/// lazySingletons and cubits as factories on their own feature branches.
void setupGetIt(Env env) {
  getIt.registerLazySingleton<Env>(() => env);
  getIt.registerLazySingleton<FirestorePaths>(() => FirestorePaths(getIt()));
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
}
