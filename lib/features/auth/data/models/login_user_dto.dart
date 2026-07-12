import 'package:fitness_app/features/auth/domain/entities/login_user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_user_dto.g.dart';

@JsonSerializable()
class LoginUserDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "firstName")
  String? firstName;
  @JsonKey(name: "lastName")
  String? lastName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "gender")
  String? gender;
  @JsonKey(name: "age")
  int? age;
  @JsonKey(name: "weight")
  int? weight;
  @JsonKey(name: "height")
  int? height;
  @JsonKey(name: "activityLevel")
  String? activityLevel;
  @JsonKey(name: "goal")
  String? goal;
  @JsonKey(name: "photo")
  String? photo;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;

  LoginUserDto({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.activityLevel,
    this.goal,
    this.photo,
    this.createdAt,
  });

  factory LoginUserDto.fromJson(Map<String, dynamic> json) => _$LoginUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserDtoToJson(this);

  LoginUserEntity toDomain() {
    return LoginUserEntity(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      gender: gender ?? '',
      age: age ?? 0,
      weight: weight ?? 0,
      height: height ?? 0,
      activityLevel: activityLevel ?? '',
      goal: goal ?? '',
      photo: photo ?? '',
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}