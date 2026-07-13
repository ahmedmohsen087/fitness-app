import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/auth/auth_manager.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/auth/api/request_models/login_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/login_user_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:fitness_app/features/auth/presentation/view_models/login_events.dart';
import 'package:fitness_app/features/auth/presentation/view_models/login_state.dart';
import 'package:fitness_app/features/auth/presentation/view_models/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_view_model_test.mocks.dart';


final tLoginEntity = LoginUserEntity(id: '', firstName: '', lastName: '', email: '', gender: '', age: 45, weight: 45, height: 45, activityLevel: '', goal: '', photo: '', createdAt: DateTime.now()

);



@GenerateMocks([LoginUseCase, AuthManager])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<LoginUserEntity>>(
      SuccessBaseResponse<LoginUserEntity>(
        data:  LoginUserEntity(
            id: '', firstName: '', lastName: '', email: '', gender: '', age: 45, weight: 45, height: 45, activityLevel: '', goal: '', photo: '', createdAt: DateTime.now()
        ),
      ),
    );
  });

  late MockLoginUseCase mockLoginUseCase;
  late MockAuthManager mockAuthManager;
  late LoginViewModel sut;

  final tLoginRequestModel = LoginRequestModel(
    email: 'test@example.com',
    password: 'password123',
  );

  final tAuthResponseEntity = LoginUserEntity(
      id: '', firstName: '', lastName: '', email: '', gender: '', age: 45, weight: 45, height: 45, activityLevel: '', goal: '', photo: '', createdAt: DateTime.now()
  );

  void stubLoginSuccess() {
    when(mockLoginUseCase.execute(loginRequestModel: tLoginRequestModel))
        .thenAnswer(
      (_) async =>
          SuccessBaseResponse<LoginUserEntity>(data: tAuthResponseEntity),
    );
  }

  void stubLoginError(String message) {
    when(mockLoginUseCase.execute(loginRequestModel: tLoginRequestModel))
        .thenAnswer(
      (_) async => ErrorBaseResponse<LoginUserEntity>(
        errorMessage: message,
      ),
    );
  }

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockAuthManager = MockAuthManager();
    sut = LoginViewModel(mockLoginUseCase, mockAuthManager);
  });

  tearDown(() => sut.close());

  group('Initial State', () {
    test('emits the correct initial state on creation', () {
      expect(sut.state, const LoginState());
      expect(sut.state.loginState, isA<BaseState<LoginUserEntity>>());
    });
  });

  group('LoginRequestEvent', () {
    blocTest<LoginViewModel, LoginState>(
      'emits [loading, success] states when login usecase succeeds',
      build: () {
        stubLoginSuccess();
        return sut;
      },
      act: (vm) =>
          vm.doEvent(LoginRequestEvent(requestModel: tLoginRequestModel)),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginState.isLoading,
          'loginState.isLoading',
          isTrue,
        ),
        isA<LoginState>()
            .having(
              (s) => s.loginState.isLoading,
              'loginState.isLoading',
              isFalse,
            )
            .having(
              (s) => s.loginState.data,
              'loginState.data',
              tAuthResponseEntity,
            ),
      ],
      verify: (_) {
        verify(
          mockLoginUseCase.execute(loginRequestModel: tLoginRequestModel),
        ).called(1);
        verifyNoMoreInteractions(mockLoginUseCase);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'calls AuthManager.setRememberMe when RememberMeEvent is dispatched',
      build: () {
        return sut;
      },
      act: (vm) {
        when(mockAuthManager.setRememberMe(true))
            .thenAnswer((_) async {});
        vm.doEvent(RememberMeEvent(rememberMe: true));
      },
      verify: (_) {
        verify(mockAuthManager.setRememberMe(true)).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [loading, error] states when login usecase fails',
      build: () {
        stubLoginError('Invalid credentials');
        return sut;
      },
      act: (vm) =>
          vm.doEvent(LoginRequestEvent(requestModel: tLoginRequestModel)),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginState.isLoading,
          'loginState.isLoading',
          isTrue,
        ),
        isA<LoginState>()
            .having(
              (s) => s.loginState.isLoading,
              'loginState.isLoading',
              isFalse,
            )
            .having(
              (s) => s.loginState.msg,
              'loginState.msg',
              'Invalid credentials',
            ),
      ],
      verify: (_) {
        verify(
          mockLoginUseCase.execute(loginRequestModel: tLoginRequestModel),
        ).called(1);
        verifyNoMoreInteractions(mockLoginUseCase);
      },
    );
  });
}
