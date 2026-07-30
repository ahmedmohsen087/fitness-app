import 'package:equatable/equatable.dart';

import '../../../../core/values/register_constants.dart';

class EditProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final int weight;
  final FitnessGoal goal;
  final ActivityLevel activityLevel;

  const EditProfileParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.weight,
    required this.goal,
    required this.activityLevel,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    weight,
    goal,
    activityLevel,
  ];
}
