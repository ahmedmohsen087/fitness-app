import 'package:equatable/equatable.dart';

import '../../../../config/base_state/base_state.dart';
import '../../../../core/values/register_constants.dart';
import '../../domain/entities/register_response_entity.dart';

enum RegisterFlowStep { gender, age, weight, height, goal, activity }

class RegisterState extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? rePassword;
  final Gender? gender;
  final int? age;
  final int? weight;
  final int? height;
  final FitnessGoal? goal;
  final ActivityLevel? activityLevel;
  final RegisterFlowStep? navigationTarget;
  final int navigationRequestId;
  final BaseState<RegisterResponseEntity> submitState;

  const RegisterState({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.rePassword,
    this.gender,
    this.age = RegisterConstants.defaultAge,
    this.weight = RegisterConstants.defaultWeight,
    this.height = RegisterConstants.defaultHeight,
    this.goal,
    this.activityLevel,
    this.navigationTarget,
    this.navigationRequestId = 0,
    this.submitState = const BaseState(),
  });

  RegisterState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? rePassword,
    Gender? gender,
    int? age,
    int? weight,
    int? height,
    FitnessGoal? goal,
    ActivityLevel? activityLevel,
    RegisterFlowStep? navigationTarget,
    int? navigationRequestId,
    BaseState<RegisterResponseEntity>? submitState,
  }) {
    return RegisterState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      navigationTarget: navigationTarget ?? this.navigationTarget,
      navigationRequestId: navigationRequestId ?? this.navigationRequestId,
      submitState: submitState ?? this.submitState,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    rePassword,
    gender,
    age,
    weight,
    height,
    goal,
    activityLevel,
    navigationTarget,
    navigationRequestId,
    submitState,
  ];
}
