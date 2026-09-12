import 'package:bloc_test/bloc_test.dart';
import 'package:buy_verse_app/core_layer/user/core/models/errors/failer_models.dart';
import 'package:buy_verse_app/core_layer/user/core/params/login_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/otp_resend_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/otp_verify_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/register_param.dart';
import 'package:buy_verse_app/data_layer/user/services/shared_preferences_service.dart';
import 'package:buy_verse_app/domain_layer/user/entities/user_entites.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/user_repo_impelement.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/auth/auth_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepoImpelement extends Mock implements UserRepoImpelement {}

class MockSharedPreferencesService extends Mock implements SharedPreferencesService {}

void main() {
  late MockUserRepoImpelement mockRepository;
  late MockSharedPreferencesService mockSharedPreferencesService;

  setUpAll(() {
    registerFallbackValue(const RegisterParam(
      name: 'Test User',
      email: 'test@example.com',
      phone: '1234567890',
      password: 'password123',
    ));
    registerFallbackValue(const LoginParams(
      email: 'test@example.com',
      password: 'password123',
    ));
    registerFallbackValue(const OtpVerifyParams(
      email: 'test@example.com',
      otpCode: '123456',
    ));
    registerFallbackValue(const OtpResendParams(
      email: 'test@example.com',
    ));
  });

  setUp(() {
    mockRepository = MockUserRepoImpelement();
    mockSharedPreferencesService = MockSharedPreferencesService();
  });

  group('AuthCubit', () {
    final testUser = UserEntites(
      name: 'Test User',
      email: 'test@example.com',
      phone: '1234567890',
      token: 'test_token',
    );

    test('initial state is AuthInitial', () {
      final cubit = AuthCubit(
        repository: mockRepository,
        sharedPreferencesService: mockSharedPreferencesService,
      );
      expect(cubit.state, isA<AuthInitial>());
      cubit.close();
    });

    group('register', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthSuccess] when registration succeeds',
        setUp: () {
          when(() => mockRepository.registerUser(params: any(named: 'params')))
              .thenAnswer((_) async => Right(testUser));
          when(() => mockSharedPreferencesService.setAuthToken(any()))
              .thenAnswer((_) async => Future.value());
          when(() => mockSharedPreferencesService.setAuthName(any()))
              .thenAnswer((_) async => Future.value());
        },
        build: () => AuthCubit(
          repository: mockRepository,
          sharedPreferencesService: mockSharedPreferencesService,
        ),
        act: (cubit) => cubit.register(
          params: const RegisterParam(
            name: 'Test User',
            email: 'test@example.com',
            phone: '1234567890',
            password: 'password123',
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
        verify: (_) {
          verify(() => mockSharedPreferencesService.setAuthToken('test_token'))
              .called(1);
          verify(() => mockSharedPreferencesService.setAuthName('Test User'))
              .called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when registration fails',
        setUp: () {
          when(() => mockRepository.registerUser(params: any(named: 'params')))
              .thenAnswer((_) async => const Left(FailerModels()));
        },
        build: () => AuthCubit(
          repository: mockRepository,
          sharedPreferencesService: mockSharedPreferencesService,
        ),
        act: (cubit) => cubit.register(
          params: const RegisterParam(
            name: 'Test User',
            email: 'test@example.com',
            phone: '1234567890',
            password: 'password123',
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthError>()],
      );
    });

    group('login', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthSuccess] when login succeeds',
        setUp: () {
          when(() => mockRepository.logIN(params: any(named: 'params')))
              .thenAnswer((_) async => Right(testUser));
          when(() => mockSharedPreferencesService.setAuthToken(any()))
              .thenAnswer((_) async => Future.value());
          when(() => mockSharedPreferencesService.setAuthName(any()))
              .thenAnswer((_) async => Future.value());
        },
        build: () => AuthCubit(
          repository: mockRepository,
          sharedPreferencesService: mockSharedPreferencesService,
        ),
        act: (cubit) => cubit.login(
          params: const LoginParams(
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
        verify: (_) {
          verify(() => mockSharedPreferencesService.setAuthToken('test_token'))
              .called(1);
          verify(() => mockSharedPreferencesService.setAuthName('Test User'))
              .called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when login fails',
        setUp: () {
          when(() => mockRepository.logIN(params: any(named: 'params')))
              .thenAnswer((_) async => const Left(FailerModels()));
        },
        build: () => AuthCubit(
          repository: mockRepository,
          sharedPreferencesService: mockSharedPreferencesService,
        ),
        act: (cubit) => cubit.login(
          params: const LoginParams(
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthError>()],
      );
    });

    group('verifyOtp', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthSuccess] when OTP verification succeeds',
        setUp: () {
          when(() => mockRepository.verifyOTP(params: any(named: 'params')))
              .thenAnswer((_) async => Right(testUser));
          when(() => mockSharedPreferencesService.setAuthToken(any()))
              .thenAnswer((_) async => Future.value());
          when(() => mockSharedPreferencesService.setAuthName(any()))
              .thenAnswer((_) async => Future.value());
        },
        build: () => AuthCubit(
          repository: mockRepository,
          sharedPreferencesService: mockSharedPreferencesService,
        ),
        act: (cubit) => cubit.verifyOtp(
          params: const OtpVerifyParams(
            email: 'test@example.com',
            otpCode: '123456',
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
        verify: (_) {
          verify(() => mockSharedPreferencesService.setAuthToken('test_token'))
              .called(1);
          verify(() => mockSharedPreferencesService.setAuthName('Test User'))
              .called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when OTP verification fails',
        setUp: () {
          when(() => mockRepository.verifyOTP(params: any(named: 'params')))
              .thenAnswer((_) async => const Left(FailerModels()));
        },
        build: () => AuthCubit(
          repository: mockRepository,
          sharedPreferencesService: mockSharedPreferencesService,
        ),
        act: (cubit) => cubit.verifyOtp(
          params: const OtpVerifyParams(
            email: 'test@example.com',
            otpCode: '123456',
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthError>()],
      );
    });

    group('resendOtp', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthInitial] when OTP resend succeeds',
        setUp: () {
          when(() => mockRepository.resendOTP(params: any(named: 'params')))
              .thenAnswer((_) async => const Right(true));
        },
        build: () => AuthCubit(
          repository: mockRepository,
          sharedPreferencesService: mockSharedPreferencesService,
        ),
        act: (cubit) => cubit.resendOtp(
          params: const OtpResendParams(
            email: 'test@example.com',
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthInitial>()],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when OTP resend fails',
        setUp: () {
          when(() => mockRepository.resendOTP(params: any(named: 'params')))
              .thenAnswer((_) async => const Left(FailerModels()));
        },
        build: () => AuthCubit(
          repository: mockRepository,
          sharedPreferencesService: mockSharedPreferencesService,
        ),
        act: (cubit) => cubit.resendOtp(
          params: const OtpResendParams(
            email: 'test@example.com',
          ),
        ),
        expect: () => [isA<AuthLoading>(), isA<AuthError>()],
      );
    });

    group('clearAuthData', () {
      blocTest<AuthCubit, AuthState>(
        'calls clearAuthData on SharedPreferencesService',
        setUp: () {
          when(() => mockSharedPreferencesService.clearAuthData())
              .thenAnswer((_) async => Future.value());
        },
        build: () => AuthCubit(
          repository: mockRepository,
          sharedPreferencesService: mockSharedPreferencesService,
        ),
        act: (cubit) => cubit.clearAuthData(),
        verify: (_) {
          verify(() => mockSharedPreferencesService.clearAuthData()).called(1);
        },
      );
    });

    group('getAuthToken', () {
      blocTest<AuthCubit, AuthState>(
        'returns token from SharedPreferencesService',
        setUp: () {
          when(() => mockSharedPreferencesService.getAuthToken())
              .thenAnswer((_) async => 'test_token');
        },
        build: () => AuthCubit(
          repository: mockRepository,
          sharedPreferencesService: mockSharedPreferencesService,
        ),
        act: (cubit) async {
          final token = await cubit.getAuthToken();
          expect(token, 'test_token');
        },
        verify: (_) {
          verify(() => mockSharedPreferencesService.getAuthToken()).called(1);
        },
      );
    });
  });
}
