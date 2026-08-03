import '../../../../../core/values/register_constants.dart';
import '../../../domain/entities/profile_response_entity.dart';

sealed class EditProfileEvents {
  const EditProfileEvents();
}

class InitializeEditProfileEvent extends EditProfileEvents {
  final ProfileResponseEntity profile;

  const InitializeEditProfileEvent({required this.profile});
}

class UpdateEditWeightEvent extends EditProfileEvents {
  final int weight;

  const UpdateEditWeightEvent({required this.weight});
}

class SelectEditGoalEvent extends EditProfileEvents {
  final FitnessGoal goal;

  const SelectEditGoalEvent({required this.goal});
}

class SelectEditActivityLevelEvent extends EditProfileEvents {
  final ActivityLevel activityLevel;

  const SelectEditActivityLevelEvent({required this.activityLevel});
}

class SubmitEditProfileEvent extends EditProfileEvents {
  final String firstName;
  final String lastName;
  final String email;

  const SubmitEditProfileEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}

class SelectEditProfilePhotoEvent extends EditProfileEvents {
  const SelectEditProfilePhotoEvent();
}
