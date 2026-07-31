import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/auth/auth_manager.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_events.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_states.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_view_model_test.mocks.dart';

@GenerateMocks([LogoutUseCase, AuthManager])
void main() {
  late MockLogoutUseCase mockLogoutUseCase;
  late MockAuthManager mockAuthManager;
  late LogoutViewModel logoutViewModel;

  setUp(() {
    mockLogoutUseCase = MockLogoutUseCase();
    mockAuthManager = MockAuthManager();
    logoutViewModel = LogoutViewModel(mockLogoutUseCase, mockAuthManager);
    provideDummy<BaseResponse<RegisterResponseEntity>>(
      ErrorBaseResponse(errorMessage: ''),
    );
  });

  tearDown(() {
    logoutViewModel.close();
  });

  const tRegisterResponseEntity = RegisterResponseEntity(
    message: 'success',
    token: 'test_token',
  );

  group('LogoutViewModel', () {
    test('initial state is LogoutState with initial BaseState', () {
      expect(logoutViewModel.state, const LogoutState());
      expect(
        logoutViewModel.state.logoutState,
        isA<BaseState<RegisterResponseEntity>>(),
      );
    });

    blocTest<LogoutViewModel, LogoutState>(
      'emits [loading, success] and calls authManager.logout when LogoutRequestEvent is added and useCase succeeds',
      build: () {
        when(mockLogoutUseCase.execute()).thenAnswer(
          (_) async => SuccessBaseResponse(data: tRegisterResponseEntity),
        );
        when(mockAuthManager.logout()).thenAnswer((_) async => {});
        return logoutViewModel;
      },
      act: (viewModel) => viewModel.doEvent(LogoutRequestEvent()),
      expect: () => [
        LogoutState(logoutState: BaseState.loading()),
        LogoutState(logoutState: BaseState.success(tRegisterResponseEntity)),
      ],
      verify: (_) {
        verify(mockLogoutUseCase.execute()).called(1);
        verify(mockAuthManager.logout()).called(1);
      },
    );

    blocTest<LogoutViewModel, LogoutState>(
      'emits [loading, error] and calls authManager.logout when LogoutRequestEvent is added and useCase fails',
      build: () {
        when(mockLogoutUseCase.execute()).thenAnswer(
          (_) async => ErrorBaseResponse(errorMessage: 'Logout failed error'),
        );
        when(mockAuthManager.logout()).thenAnswer((_) async => {});
        return logoutViewModel;
      },
      act: (viewModel) => viewModel.doEvent(LogoutRequestEvent()),
      expect: () => [
        LogoutState(logoutState: BaseState.loading()),
        LogoutState(logoutState: BaseState.error('Logout failed error')),
      ],
      verify: (_) {
        verify(mockLogoutUseCase.execute()).called(1);
        verify(mockAuthManager.logout()).called(1);
      },
    );
  });
}
