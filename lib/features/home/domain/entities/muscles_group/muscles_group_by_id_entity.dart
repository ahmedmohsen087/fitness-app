import 'package:equatable/equatable.dart';

import 'muscle_by_id_entity.dart';
import 'muscles_entity.dart';

class MusclesGroupByIdEntity extends Equatable {
  final String message;
  final MusclesEntity musclesGroupDto;
  final List<MuscleByIdEntity> muscles;
  const MusclesGroupByIdEntity({
    required this.message,
    required this.musclesGroupDto,
    required this.muscles,
  });
  @override
  List<Object?> get props => [message, musclesGroupDto, muscles];
}
