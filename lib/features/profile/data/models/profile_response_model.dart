import 'package:fitness_app/features/auth/data/models/login_user_dto.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
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
  ProfileResponseEntity toProfileEntity() {
    return ProfileResponseEntity(
      id: user?.id ?? '',
      firstName: user?.firstName ?? '',
      lastName: user?.lastName ?? '',
      email: user?.email ?? '',
      gender: user?.gender ?? '',
      age: user?.age ?? 0,
      weight: user?.weight ?? 0,
      height: user?.height ?? 0,
      activityLevel: user?.activityLevel ?? '',
      goal: user?.goal ?? '',
      photo: user?.photo ?? '',
      createdAt: user?.createdAt ?? DateTime.now(),
    );
  }
}
