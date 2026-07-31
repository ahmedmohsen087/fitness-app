sealed class ChangePasswordEvent {}

class EnableAutoValidateEvent extends ChangePasswordEvent {}

class ChangePasswordRequestEvent extends ChangePasswordEvent {
  final String password;
  final String newPassword;

  ChangePasswordRequestEvent({
    required this.password,
    required this.newPassword,
  });
}
