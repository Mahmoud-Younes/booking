import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/error/firebase_error_mapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirebaseErrorMapper.map — the behavior-defining table', () {
    FirebaseException firestoreError(String code) =>
        FirebaseException(plugin: 'cloud_firestore', code: code);

    FirebaseException authError(String code) =>
        FirebaseException(plugin: 'auth', code: code);

    test('connectivity codes -> networkUnavailable (offline-pending trigger)',
        () {
      expect(FirebaseErrorMapper.map(firestoreError('unavailable')),
          FailureCode.networkUnavailable);
      expect(FirebaseErrorMapper.map(firestoreError('network-request-failed')),
          FailureCode.networkUnavailable);
      expect(FirebaseErrorMapper.map(firestoreError('deadline-exceeded')),
          FailureCode.networkUnavailable);
    });

    test('permission-denied -> ruleDenied', () {
      expect(FirebaseErrorMapper.map(firestoreError('permission-denied')),
          FailureCode.ruleDenied);
    });

    test('unauthenticated -> authRequired', () {
      expect(FirebaseErrorMapper.map(firestoreError('unauthenticated')),
          FailureCode.authRequired);
    });

    test('auth flow codes -> authRequired', () {
      expect(FirebaseErrorMapper.map(authError('wrong-password')),
          FailureCode.authRequired);
      expect(FirebaseErrorMapper.map(authError('user-not-found')),
          FailureCode.authRequired);
      expect(FirebaseErrorMapper.map(authError('email-already-in-use')),
          FailureCode.authRequired);
      expect(FirebaseErrorMapper.map(authError('weak-password')),
          FailureCode.authRequired);
    });

    test('typed booking-conflict abort -> conflictLost', () {
      expect(FirebaseErrorMapper.map(const BookingConflictException('20788')),
          FailureCode.conflictLost);
    });

    test('unknown codes keep the typed unknown (raw code stays on the failure)',
        () {
      expect(FirebaseErrorMapper.map(firestoreError('some-new-code')),
          FailureCode.unknown);
      expect(FirebaseErrorMapper.map(Exception('anything')),
          FailureCode.unknown);
    });
  });

  group('FirebaseErrorMapper.message — Arabic only, no raw Firebase text', () {
    test('every failure code maps to a non-empty Arabic message', () {
      for (final FailureCode code in FailureCode.values) {
        final String message =
            FirebaseErrorMapper.message(BookingFailure(code: code, rawCode: 'x'));
        expect(message, isNotEmpty, reason: '$code has no message');
        expect(message.contains(RegExp(r'[a-zA-Z]')), isFalse,
            reason: '$code message leaked a Latin fragment: $message');
      }
    });
  });
}
