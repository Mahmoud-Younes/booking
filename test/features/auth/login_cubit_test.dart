import 'package:booking/core/error/failure_code.dart';
import 'package:booking/core/error/result.dart';
import 'package:booking/features/auth/data/models/login_request_body.dart';
import 'package:booking/features/auth/data/repos/auth_repo.dart';
import 'package:booking/features/auth/logic/cubit/login_cubit.dart';
import 'package:booking/features/auth/logic/cubit/login_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepo extends Mock implements AuthRepo {}

class _MockUser extends Mock implements User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _MockAuthRepo repo;

  setUp(() {
    repo = _MockAuthRepo();
    registerFallbackValue(
      const LoginRequestBody(email: '', password: ''),
    );
  });

  LoginCubit buildCubit() => LoginCubit(repo);

  test('controllers are wired to the request body on submit', () async {
    final _MockUser user = _MockUser();
    when(() => repo.signIn(any(that: isA<LoginRequestBody>())))
        .thenAnswer((_) async => Result.success(user));
    final LoginCubit cubit = buildCubit()
      ..emailController.text = 'a@b.com'
      ..passwordController.text = 'secret6';
    await cubit.emitLoginStates();
    final LoginRequestBody captured =
        verify(() => repo.signIn(captureAny(that: isA<LoginRequestBody>())))
            .captured
            .first as LoginRequestBody;
    expect(captured.email, 'a@b.com');
    expect(captured.password, 'secret6');
  });

  blocTest<LoginCubit, LoginState>(
    'emits [loading, success] on a valid login',
    build: () {
      final _MockUser user = _MockUser();
      when(() => repo.signIn(any()))
          .thenAnswer((_) async => Result.success(user));
      return buildCubit()
        ..emailController.text = 'a@b.com'
        ..passwordController.text = 'secret6';
    },
    act: (LoginCubit cubit) => cubit.emitLoginStates(),
    expect: () => <dynamic>[
      const LoginState.loginLoading(),
      isA<LoginSuccess>(),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [loading, failure] and maps the raw Firebase code',
    build: () {
      when(() => repo.signIn(any())).thenAnswer(
        (_) async => Result.failure(
          BookingFailure(code: FailureCode.authRequired, rawCode: 'wrong-password'),
        ),
      );
      return buildCubit()
        ..emailController.text = 'a@b.com'
        ..passwordController.text = 'bad-pass';
    },
    act: (LoginCubit cubit) => cubit.emitLoginStates(),
    expect: () => <dynamic>[
      const LoginState.loginLoading(),
      isA<LoginFailure>().having(
        (LoginFailure s) => s.failure.code,
        'failure code',
        FailureCode.authRequired,
      ),
    ],
  );

  test('invalid form does not call the repo', () async {
    final LoginCubit cubit = buildCubit();
    cubit.emailController.text = 'not-an-email';
    cubit.passwordController.text = '1';
    await cubit.emitLoginStates();
    verifyNever(() => repo.signIn(any()));
  });
}
