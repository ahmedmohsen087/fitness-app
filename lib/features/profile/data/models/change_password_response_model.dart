import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/change_password_entity.dart';

part 'change_password_response_model.g.dart';

@JsonSerializable(createToJson: false)
class ChangePasswordResponseModel {
  final String? message;
  final String? token;

  const ChangePasswordResponseModel({this.message, this.token});

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseModelFromJson(json);

  ChangePasswordEntity toEntity() =>
      ChangePasswordEntity(message: message, token: token);
}
