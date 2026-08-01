import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/values/register_constants.dart';
import 'package:fitness_app/features/profile/domain/entities/edit_profile_params.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_message_entity.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
import 'package:fitness_app/features/profile/domain/entities/upload_profile_photo_params.dart';
import 'package:fitness_app/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:fitness_app/features/profile/domain/use_cases/pick_profile_photo_use_case.dart';
import 'package:fitness_app/features/profile/domain/use_cases/upload_profile_photo_use_case.dart';
import 'package:fitness_app/features/profile/presentation/view_models/edit_profile_view_models/edit_profile_events.dart';
import 'package:fitness_app/features/profile/presentation/view_models/edit_profile_view_models/edit_profile_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/edit_profile_view_models/edit_profile_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_view_model_test.mocks.dart';

@GenerateMocks([
  EditProfileUseCase,
  UploadProfilePhotoUseCase,
  PickProfilePhotoUseCase,
])
void main() {
  late MockEditProfileUseCase editProfileUseCase;
  late MockUploadProfilePhotoUseCase uploadProfilePhotoUseCase;
  late MockPickProfilePhotoUseCase pickProfilePhotoUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<ProfileResponseEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<ProfileMessageEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy(
      const EditProfileParams(
        firstName: 'First',
        lastName: 'Last',
        email: 'first@example.com',
        weight: 70,
        goal: FitnessGoal.gainWeight,
        activityLevel: ActivityLevel.level1,
      ),
    );
    provideDummy(
      const UploadProfilePhotoParams(path: 'photo.jpg', fileName: 'photo.jpg'),
    );
  });

  setUp(() {
    editProfileUseCase = MockEditProfileUseCase();
    uploadProfilePhotoUseCase = MockUploadProfilePhotoUseCase();
    pickProfilePhotoUseCase = MockPickProfilePhotoUseCase();
  });

  EditProfileViewModel buildViewModel() => EditProfileViewModel(
    editProfileUseCase,
    uploadProfilePhotoUseCase,
    pickProfilePhotoUseCase,
  );

  blocTest<EditProfileViewModel, EditProfileState>(
    'initializes the editable values from the profile',
    build: buildViewModel,
    act: (viewModel) =>
        viewModel.doEvent(InitializeEditProfileEvent(profile: _profile)),
    expect: () => [
      EditProfileState(
        profile: _profile,
        weight: 70,
        goal: FitnessGoal.gainWeight,
        activityLevel: ActivityLevel.level1,
      ),
    ],
  );

  blocTest<EditProfileViewModel, EditProfileState>(
    'submits typed profile values and emits loading then success',
    build: () {
      when(
        editProfileUseCase.execute(any),
      ).thenAnswer((_) async => SuccessBaseResponse(data: _updatedProfile));
      return buildViewModel()
        ..doEvent(InitializeEditProfileEvent(profile: _profile));
    },
    act: (viewModel) => viewModel.doEvent(
      const SubmitEditProfileEvent(
        firstName: 'Updated',
        lastName: 'User',
        email: 'updated@example.com',
      ),
    ),
    expect: () => [
      isA<EditProfileState>().having(
        (state) => state.submitState.isLoading,
        'loading',
        isTrue,
      ),
      isA<EditProfileState>()
          .having(
            (state) => state.submitState.data,
            'updated profile',
            _updatedProfile,
          )
          .having(
            (state) => state.page,
            'details page',
            EditProfilePage.details,
          ),
    ],
    verify: (_) {
      final captured =
          verify(editProfileUseCase.execute(captureAny)).captured.single
              as EditProfileParams;
      expect(captured.firstName, 'Updated');
      expect(captured.goal, FitnessGoal.gainWeight);
      expect(captured.activityLevel, ActivityLevel.level1);
    },
  );

  blocTest<EditProfileViewModel, EditProfileState>(
    'compresses and uploads a selected photo',
    build: () {
      when(pickProfilePhotoUseCase.execute()).thenAnswer(
        (_) async => const UploadProfilePhotoParams(
          path: 'photo.jpg',
          fileName: 'photo.jpg',
        ),
      );
      when(uploadProfilePhotoUseCase.execute(any)).thenAnswer(
        (_) async =>
            SuccessBaseResponse(data: ProfileMessageEntity(message: 'success')),
      );
      return buildViewModel();
    },
    act: (viewModel) => viewModel.doEvent(const SelectEditProfilePhotoEvent()),
    expect: () => [
      isA<EditProfileState>()
          .having((state) => state.localPhotoPath, 'path', 'photo.jpg')
          .having(
            (state) => state.uploadPhotoState.isLoading,
            'loading',
            isTrue,
          ),
      isA<EditProfileState>().having(
        (state) => state.uploadPhotoState.data?.message,
        'message',
        'success',
      ),
    ],
    verify: (_) {
      verify(pickProfilePhotoUseCase.execute()).called(1);
      verify(uploadProfilePhotoUseCase.execute(any)).called(1);
    },
  );

  blocTest<EditProfileViewModel, EditProfileState>(
    'does not upload when photo selection is cancelled',
    build: () {
      when(pickProfilePhotoUseCase.execute()).thenAnswer((_) async => null);
      return buildViewModel();
    },
    act: (viewModel) => viewModel.doEvent(const SelectEditProfilePhotoEvent()),
    expect: () => <EditProfileState>[],
    verify: (_) {
      verify(pickProfilePhotoUseCase.execute()).called(1);
      verifyNever(uploadProfilePhotoUseCase.execute(any));
    },
  );
}

final _profile = ProfileResponseEntity(
  id: '1',
  firstName: 'First',
  lastName: 'Last',
  email: 'first@example.com',
  gender: 'male',
  age: 30,
  weight: 70,
  height: 170,
  activityLevel: 'level1',
  goal: 'Gain weight',
  photo: 'profile.jpg',
  createdAt: DateTime(2026),
);

final _updatedProfile = ProfileResponseEntity(
  id: '1',
  firstName: 'Updated',
  lastName: 'User',
  email: 'updated@example.com',
  gender: 'male',
  age: 30,
  weight: 70,
  height: 170,
  activityLevel: 'level1',
  goal: 'Gain weight',
  photo: 'profile.jpg',
  createdAt: DateTime(2026),
);
