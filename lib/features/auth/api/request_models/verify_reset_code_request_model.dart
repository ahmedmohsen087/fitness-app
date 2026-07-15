import 'package:fitness_app/core/values/api_parameters.dart';

class VerifyResetCodeRequestModel {
  final String resetCode;

  const VerifyResetCodeRequestModel({required this.resetCode});

  VerifyResetCodeRequestModel copyWith({String? email, String? resetCode}) {
    return VerifyResetCodeRequestModel(resetCode: resetCode ?? this.resetCode);
  }

  Map<String, dynamic> toJson() {
    return {ApiParameters.resetCode: resetCode};
  }
}
