import 'package:equatable/equatable.dart';

import 'user_entity.dart';

class RegisterResponseEntity extends Equatable {
  final String? message;
  final UserEntity? user;
  final String? token;

  const RegisterResponseEntity({this.message, this.user, this.token});

  @override
  List<Object?> get props => [message, user, token];
}
