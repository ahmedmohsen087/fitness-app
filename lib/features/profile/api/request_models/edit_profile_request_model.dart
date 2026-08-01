import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/edit_profile_params.dart';

part 'edit_profile_request_model.g.dart';

@JsonSerializable(createFactory: false)
class EditProfileRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final int weight;
  final String goal;
  final String activityLevel;

  const EditProfileRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.weight,
    required this.goal,
    required this.activityLevel,
  });

  factory EditProfileRequestModel.fromParams(EditProfileParams params) =>
      EditProfileRequestModel(
        firstName: params.firstName,
        lastName: params.lastName,
        email: params.email,
        weight: params.weight,
        goal: params.goal.apiValue,
        activityLevel: params.activityLevel.apiValue,
      );

  Map<String, dynamic> toJson() => _$EditProfileRequestModelToJson(this);
}
