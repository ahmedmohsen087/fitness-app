import 'package:equatable/equatable.dart';

class ChatActionParamsEntity extends Equatable {
  final String? mealId;
  final String? exerciseId;
  final String? workoutId;
  final String? muscleName;
  final String? image;

  const ChatActionParamsEntity({
    this.mealId,
    this.exerciseId,
    this.workoutId,
    this.muscleName,
    this.image,
  });

  @override
  List<Object?> get props => [
        mealId,
        exerciseId,
        workoutId,
        muscleName,
        image,
      ];
}
