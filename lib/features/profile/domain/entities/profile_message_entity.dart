import 'package:equatable/equatable.dart';

class ProfileMessageEntity extends Equatable {
  final String message;

  const ProfileMessageEntity({required this.message});

  @override
  List<Object?> get props => [message];
}
