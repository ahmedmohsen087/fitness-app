import 'package:equatable/equatable.dart';

import 'muscles_entity.dart';

class MusclesGroupEntity extends Equatable {
  final String message;
  final List<MusclesEntity> musclesGroup;

  const MusclesGroupEntity({required this.message, required this.musclesGroup});

  @override
  List<Object?> get props => [message, musclesGroup];
}
