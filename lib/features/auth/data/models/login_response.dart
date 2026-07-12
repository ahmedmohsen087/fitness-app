import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/login_user_entity.dart';
import 'login_user_dto.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "user")
  LoginUserDto? user;
  @JsonKey(name: "token")
  String? token;

  LoginResponse({
    this.message,
    this.user,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  LoginUserEntity toEntity() {
    return user?.toDomain() ?? LoginUserEntity(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      gender: '',
      age: 0,
      weight: 0,
      height: 0,
      activityLevel: '',
      goal: '',
      photo: '',
      createdAt: DateTime.now(),
    );
  }
}


