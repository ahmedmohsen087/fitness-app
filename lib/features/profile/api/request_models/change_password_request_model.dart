import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_model.g.dart';

@JsonSerializable(createFactory: false)
class ChangePasswordRequestModel {
  @JsonKey(name: 'password')
  final String password;

  @JsonKey(name: 'newPassword')
  final String newPassword;

  const ChangePasswordRequestModel({
    required this.password,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => _$ChangePasswordRequestModelToJson(this);
}
