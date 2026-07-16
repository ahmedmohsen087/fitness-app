import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/register_params.dart';

part 'register_request_model.g.dart';

@JsonSerializable(createFactory: false)
class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String rePassword;
  final String gender;
  final int height;
  final int weight;
  final int age;
  final String goal;
  final String activityLevel;

  const RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.goal,
    required this.activityLevel,
  });

  factory RegisterRequestModel.fromParams(RegisterParams params) =>
      RegisterRequestModel(
        firstName: params.firstName,
        lastName: params.lastName,
        email: params.email,
        password: params.password,
        rePassword: params.rePassword,
        gender: params.gender,
        height: params.height,
        weight: params.weight,
        age: params.age,
        goal: params.goal,
        activityLevel: params.activityLevel,
      );

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
