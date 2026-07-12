import 'package:json_annotation/json_annotation.dart';
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
}


