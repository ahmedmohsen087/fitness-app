import 'register_state.dart';

sealed class RegisterEvents {
  const RegisterEvents();
}

class ContinueToGenderEvent extends RegisterEvents {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String rePassword;

  const ContinueToGenderEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.rePassword,
  });
}

class ContinueRegistrationEvent extends RegisterEvents {
  final RegisterFlowStep target;

  const ContinueRegistrationEvent({required this.target});
}

class SelectGenderEvent extends RegisterEvents {
  final String gender;

  const SelectGenderEvent({required this.gender});
}

class UpdateAgeEvent extends RegisterEvents {
  final int age;

  const UpdateAgeEvent({required this.age});
}

class UpdateWeightEvent extends RegisterEvents {
  final int weight;

  const UpdateWeightEvent({required this.weight});
}

class UpdateHeightEvent extends RegisterEvents {
  final int height;

  const UpdateHeightEvent({required this.height});
}

class SelectGoalEvent extends RegisterEvents {
  final String goal;

  const SelectGoalEvent({required this.goal});
}

class SelectActivityLevelEvent extends RegisterEvents {
  final String activityLevel;

  const SelectActivityLevelEvent({required this.activityLevel});
}

class SubmitRegisterEvent extends RegisterEvents {
  const SubmitRegisterEvent();
}
