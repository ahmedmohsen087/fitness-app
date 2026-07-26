import 'package:fitness_app/core/shared/data/models/login_user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_response_model.g.dart';

@JsonSerializable()
class ProfileResponseModel {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "user")
  LoginUserDto? user;

  ProfileResponseModel({this.message, this.user});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
}
