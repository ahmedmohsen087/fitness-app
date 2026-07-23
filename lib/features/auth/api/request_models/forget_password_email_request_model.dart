import 'package:fitness_app/core/values/api_parameters.dart';

class ForgetPasswordEmailRequestModel {
  final String email;

  const ForgetPasswordEmailRequestModel({required this.email});

  ForgetPasswordEmailRequestModel copyWith({String? email}) {
    return ForgetPasswordEmailRequestModel(email: email ?? this.email);
  }

  Map<String, dynamic> toJson() {
    return {ApiParameters.email: email};
  }
}
