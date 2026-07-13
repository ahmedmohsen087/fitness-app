import 'package:equatable/equatable.dart';

class AuthResponseEntity extends Equatable {
  final String? message;
  final String? token;

  const AuthResponseEntity({this.message, this.token});

  @override
  List<Object?> get props => [message, token];

  AuthResponseEntity copyWith({String? message, String? token}) {
    return AuthResponseEntity(
      message: message ?? this.message,
      token: token ?? this.token,
    );
  }
}
