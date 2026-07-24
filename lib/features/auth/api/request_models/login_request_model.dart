import '../../../../core/values/api_parameters.dart';

class LoginRequestModel {
  final String email;
  final String password;

  const LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    ApiParameters.email: email,
    ApiParameters.password: password,
  };
}
