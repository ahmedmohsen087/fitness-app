import 'package:equatable/equatable.dart';

import '../../../../../config/base_state/base_state.dart';
import '../../../../../core/values/register_constants.dart';
import '../../../domain/entities/profile_message_entity.dart';
import '../../../domain/entities/profile_response_entity.dart';

class EditProfileState extends Equatable {
  final ProfileResponseEntity? profile;
  final int? weight;
  final FitnessGoal? goal;
  final ActivityLevel? activityLevel;
  final String? localPhotoPath;
  final BaseState<ProfileResponseEntity> submitState;
  final BaseState<ProfileMessageEntity> uploadPhotoState;

  const EditProfileState({
    this.profile,
    this.weight,
    this.goal,
    this.activityLevel,
    this.localPhotoPath,
    this.submitState = const BaseState(),
    this.uploadPhotoState = const BaseState(),
  });

  EditProfileState copyWith({
    ProfileResponseEntity? profile,
    int? weight,
    FitnessGoal? goal,
    ActivityLevel? activityLevel,
    String? localPhotoPath,
    bool clearLocalPhotoPath = false,
    BaseState<ProfileResponseEntity>? submitState,
    BaseState<ProfileMessageEntity>? uploadPhotoState,
  }) {
    return EditProfileState(
      profile: profile ?? this.profile,
      weight: weight ?? this.weight,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      localPhotoPath: clearLocalPhotoPath
          ? null
          : localPhotoPath ?? this.localPhotoPath,
      submitState: submitState ?? this.submitState,
      uploadPhotoState: uploadPhotoState ?? this.uploadPhotoState,
    );
  }

  @override
  List<Object?> get props => [
    profile,
    weight,
    goal,
    activityLevel,
    localPhotoPath,
    submitState,
    uploadPhotoState,
  ];
}
