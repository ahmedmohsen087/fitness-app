import 'package:fitness_app/core/values/api_parameters.dart';

class ResetPasswordRequestModel {
  final String password;
  final String newPassword;

  const ResetPasswordRequestModel({
    required this.password,
    required this.newPassword,
  });

  ResetPasswordRequestModel copyWith({String? password, String? newPassword}) {
    return ResetPasswordRequestModel(
      password: password ?? this.password,
      newPassword: newPassword ?? this.newPassword,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiParameters.password: password,
      ApiParameters.newPassword: newPassword,
    };
  }
}
