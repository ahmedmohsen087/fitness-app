import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/register_response_entity.dart';
import 'user_model.dart';

part 'register_response_model.g.dart';

@JsonSerializable(createToJson: false)
class RegisterResponseModel {
  final String? message;
  final UserModel? user;
  final String? token;

  const RegisterResponseModel({this.message, this.user, this.token});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  RegisterResponseEntity toEntity() => RegisterResponseEntity(
    message: message,
    user: user?.toEntity(),
    token: token,
  );
}
