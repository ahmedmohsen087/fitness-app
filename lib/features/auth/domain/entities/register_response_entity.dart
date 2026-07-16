import 'user_entity.dart';

class RegisterResponseEntity {
  final String? message;
  final UserEntity? user;
  final String? token;

  const RegisterResponseEntity({this.message, this.user, this.token});
}
