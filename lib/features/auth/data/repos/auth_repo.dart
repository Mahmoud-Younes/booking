import 'package:booking/core/data/firestore_paths.dart';
import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/error/firebase_error_mapper.dart';
import 'package:booking/core/error/result.dart';
import 'package:booking/features/auth/data/models/login_request_body.dart';
import 'package:booking/features/auth/data/models/sign_up_request_body.dart';
import 'package:booking/features/auth/data/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Auth I/O boundary — the only place Firebase Auth is touched.
///
/// Session source of truth is FirebaseAuth's own persistence via
/// `authStateChanges` (no manual uId copies in SharedPreferences — the
/// `social` precedent drifts from reality).
class AuthRepo {
  AuthRepo(this._auth, this._db, this._paths);

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final FirestorePaths _paths;

  Future<Result<User>> signIn(LoginRequestBody body) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: body.email,
        password: body.password,
      );
      return Result.success(credential.user!);
    } catch (error) {
      return Result.failure(_failure(error));
    }
  }

  Future<Result<User>> signUp(SignUpRequestBody body) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: body.email,
        password: body.password,
      );
      final String uid = credential.user!.uid;
      // Register-then-write-profile: a fresh account always has a document.
      final UserProfile profile = UserProfile(
        uid: uid,
        name: body.name,
        email: body.email,
      );
      await _db
          .collection(_paths.users())
          .withUserProfileConverter()
          .doc(uid)
          .set(profile);
      return Result.success(credential.user!);
    } catch (error) {
      return Result.failure(_failure(error));
    }
  }

  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return const Result.success(null);
    } catch (error) {
      return Result.failure(_failure(error));
    }
  }

  BookingFailure _failure(Object error) => BookingFailure(
        code: FirebaseErrorMapper.map(error),
        rawCode: error is FirebaseException ? error.code : error.toString(),
      );
}
