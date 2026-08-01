import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
import 'package:fitness_app/features/profile/domain/use_cases/get_profile_data_usecase.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_events.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_view_model_test.mocks.dart';

@GenerateMocks([GetProfileDataUseCase])
void main() {
  provideDummy<BaseResponse<ProfileResponseEntity>>(
    ErrorBaseResponse(errorMessage: 'dummy'),
  );

  late MockGetProfileDataUseCase getProfileDataUseCase;

  final tProfileEntity = ProfileResponseEntity(
    id: '1',
    firstName: 'Mohamed',
    lastName: 'Ebrahim',
    email: 'mohamed@example.com',
    gender: 'male',
    age: 25,
    weight: 80,
    height: 180,
    activityLevel: 'active',
    goal: 'muscle_gain',
    photo: 'profile.png',
    createdAt: DateTime.now(),
  );

  setUp(() {
    getProfileDataUseCase = MockGetProfileDataUseCase();
  });

  blocTest<GetProfileViewModel, GetProfileState>(
    'emits loading then success state when profile data is fetched successfully',
    build: () {
      when(
        getProfileDataUseCase.getProfileData(),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tProfileEntity));
      return GetProfileViewModel(getProfileDataUseCase);
    },
    act: (viewModel) => viewModel.doEvent(const RefreshProfileEvent()),
    expect: () => [
      GetProfileState(
        getProfileState: BaseState<ProfileResponseEntity>.loading(),
      ),
      GetProfileState(
        getProfileState: BaseState<ProfileResponseEntity>.success(
          tProfileEntity,
        ),
      ),
    ],
    verify: (_) {
      verify(getProfileDataUseCase.getProfileData()).called(1);
    },
  );

  blocTest<GetProfileViewModel, GetProfileState>(
    'emits loading then error state when fetching profile data fails',
    build: () {
      when(getProfileDataUseCase.getProfileData()).thenAnswer(
        (_) async => ErrorBaseResponse(errorMessage: 'Server Error'),
      );
      return GetProfileViewModel(getProfileDataUseCase);
    },
    act: (viewModel) => viewModel.doEvent(const RefreshProfileEvent()),
    expect: () => [
      GetProfileState(
        getProfileState: BaseState<ProfileResponseEntity>.loading(),
      ),
      GetProfileState(
        getProfileState: BaseState<ProfileResponseEntity>.error('Server Error'),
      ),
    ],
    verify: (_) {
      verify(getProfileDataUseCase.getProfileData()).called(1);
    },
  );

  test(
    'ignores older profile responses that finish last during concurrent requests',
    () async {
      final firstCompleter = Completer<BaseResponse<ProfileResponseEntity>>();
      final secondCompleter = Completer<BaseResponse<ProfileResponseEntity>>();

      when(
        getProfileDataUseCase.getProfileData(),
      ).thenAnswer((_) => firstCompleter.future);
      final viewModel = GetProfileViewModel(getProfileDataUseCase);

      viewModel.doEvent(const RefreshProfileEvent());

      when(
        getProfileDataUseCase.getProfileData(),
      ).thenAnswer((_) => secondCompleter.future);
      viewModel.doEvent(const RefreshProfileEvent());

      firstCompleter.complete(
        ErrorBaseResponse(errorMessage: 'outdated_error'),
      );
      await Future<void>.delayed(Duration.zero);

      secondCompleter.complete(SuccessBaseResponse(data: tProfileEntity));
      await Future<void>.delayed(Duration.zero);

      final expectedState = GetProfileState(
        getProfileState: BaseState<ProfileResponseEntity>.success(
          tProfileEntity,
        ),
      );

      expect(viewModel.state, expectedState);
      await viewModel.close();
    },
  );
}
