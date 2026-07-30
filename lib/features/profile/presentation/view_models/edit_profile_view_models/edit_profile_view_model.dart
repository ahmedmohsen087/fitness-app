import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../../../core/values/app_strings.dart';
import '../../../../../core/values/register_constants.dart';
import '../../../domain/entities/edit_profile_params.dart';
import '../../../domain/entities/profile_message_entity.dart';
import '../../../domain/entities/profile_response_entity.dart';
import '../../../domain/use_cases/edit_profile_use_case.dart';
import '../../../domain/use_cases/pick_profile_photo_use_case.dart';
import '../../../domain/use_cases/upload_profile_photo_use_case.dart';
import 'edit_profile_events.dart';
import 'edit_profile_states.dart';

@injectable
class EditProfileViewModel extends Cubit<EditProfileState> {
  final EditProfileUseCase _editProfileUseCase;
  final UploadProfilePhotoUseCase _uploadProfilePhotoUseCase;
  final PickProfilePhotoUseCase _pickProfilePhotoUseCase;

  EditProfileViewModel(
    this._editProfileUseCase,
    this._uploadProfilePhotoUseCase,
    this._pickProfilePhotoUseCase,
  ) : super(const EditProfileState());

  Future<void> doEvent(EditProfileEvents event) async {
    switch (event) {
      case InitializeEditProfileEvent():
        _initialize(event.profile);
      case UpdateEditWeightEvent():
        emit(state.copyWith(weight: event.weight));
      case SelectEditGoalEvent():
        emit(state.copyWith(goal: event.goal));
      case SelectEditActivityLevelEvent():
        emit(state.copyWith(activityLevel: event.activityLevel));
      case ChangeEditProfilePageEvent():
        emit(state.copyWith(page: event.page));
      case SubmitEditProfileEvent():
        await _submit(event);
      case SelectEditProfilePhotoEvent():
        await _pickAndUploadPhoto();
    }
  }

  void _initialize(ProfileResponseEntity profile) {
    emit(
      state.copyWith(
        profile: profile,
        weight: profile.weight,
        goal: FitnessGoal.fromApiValue(profile.goal),
        activityLevel: ActivityLevel.fromApiValue(profile.activityLevel),
      ),
    );
  }

  Future<void> _submit(SubmitEditProfileEvent event) async {
    final weight = state.weight;
    final goal = state.goal;
    final activityLevel = state.activityLevel;
    if (event.firstName.trim().isEmpty ||
        event.lastName.trim().isEmpty ||
        event.email.trim().isEmpty ||
        weight == null ||
        goal == null ||
        activityLevel == null) {
      emit(
        state.copyWith(
          submitState: BaseState.error(AppStrings.incompleteProfileData),
        ),
      );
      return;
    }

    emit(state.copyWith(submitState: BaseState.loading()));
    final response = await _editProfileUseCase.execute(
      EditProfileParams(
        firstName: event.firstName.trim(),
        lastName: event.lastName.trim(),
        email: event.email.trim(),
        weight: weight,
        goal: goal,
        activityLevel: activityLevel,
      ),
    );

    switch (response) {
      case SuccessBaseResponse<ProfileResponseEntity>(data: final profile):
        emit(
          state.copyWith(
            profile: profile,
            weight: profile.weight,
            goal: FitnessGoal.fromApiValue(profile.goal) ?? goal,
            activityLevel:
                ActivityLevel.fromApiValue(profile.activityLevel) ??
                activityLevel,
            page: EditProfilePage.details,
            submitState: BaseState.success(profile),
          ),
        );
      case ErrorBaseResponse<ProfileResponseEntity>(
        errorMessage: final errorMessage,
      ):
        emit(state.copyWith(submitState: BaseState.error(errorMessage)));
    }
  }

  Future<void> _pickAndUploadPhoto() async {
    final photo = await _pickProfilePhotoUseCase.execute();
    if (photo == null) return;

    emit(
      state.copyWith(
        localPhotoPath: photo.path,
        uploadPhotoState: BaseState.loading(),
      ),
    );
    final response = await _uploadProfilePhotoUseCase.execute(photo);

    switch (response) {
      case SuccessBaseResponse<ProfileMessageEntity>(data: final message):
        emit(state.copyWith(uploadPhotoState: BaseState.success(message)));
      case ErrorBaseResponse<ProfileMessageEntity>(
        errorMessage: final errorMessage,
      ):
        emit(
          state.copyWith(
            localPhotoPath: '',
            uploadPhotoState: BaseState.error(errorMessage),
          ),
        );
    }
  }
}
