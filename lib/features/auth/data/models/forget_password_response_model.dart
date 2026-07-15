import 'package:json_annotation/json_annotation.dart';

part 'forget_password_response_model.g.dart';

@JsonSerializable()
class ForgetPasswordResponseModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "token")
  final String? token;

  @JsonKey(name: "info")
  final String? info;
  @JsonKey(name: "status")
  final String? status;

  const ForgetPasswordResponseModel({
    this.message,
    this.token,
    this.info,
    this.status,
  });

  factory ForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetPasswordResponseModelToJson(this);
}
