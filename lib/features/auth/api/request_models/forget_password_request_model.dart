import 'package:fitness_app/core/values/api_parameters.dart';

class ForgetPasswordRequestModel {
  final String? email;
  final String? newPassword;
  final String? resetCode;

  const ForgetPasswordRequestModel({
    this.email,
    this.newPassword,
    this.resetCode,
  });

  ForgetPasswordRequestModel copyWith({
    String? email,
    String? newPassword,
    String? resetCode,
  }) {
    return ForgetPasswordRequestModel(
      email: email ?? this.email,
      newPassword: newPassword ?? this.newPassword,
      resetCode: resetCode ?? this.resetCode,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (email != null) {
      data[ApiParameters.email] = email;
    }
    if (newPassword != null) {
      data[ApiParameters.password] = newPassword;
    }
    if (resetCode != null) {
      data[ApiParameters.resetCode] = resetCode;
    }

    return data;
  }
}
