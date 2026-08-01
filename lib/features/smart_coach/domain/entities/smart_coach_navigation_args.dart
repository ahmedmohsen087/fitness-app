import 'package:fitness_app/features/fitness/presentation/screens/exercise_screen.dart';

abstract class SmartCoachNavigationArgs {
  const SmartCoachNavigationArgs();
}

class SmartCoachFoodDetailsArgs extends SmartCoachNavigationArgs {
  final String mealId;
  final String? mealName;

  const SmartCoachFoodDetailsArgs({
    required this.mealId,
    this.mealName,
  });
}

class SmartCoachExerciseArgs extends SmartCoachNavigationArgs {
  final String primeMoverMuscleId;
  final String muscleName;
  final String image;
  final String? initialLevelId;

  const SmartCoachExerciseArgs({
    required this.primeMoverMuscleId,
    required this.muscleName,
    required this.image,
    this.initialLevelId,
  });

  ExerciseScreenArgs toExerciseScreenArgs() {
    return ExerciseScreenArgs(
      primeMoverMuscleId: primeMoverMuscleId,
      muscleName: muscleName,
      image: image,
      initialLevelId: initialLevelId,
    );
  }
}

class SmartCoachWorkoutsArgs extends SmartCoachNavigationArgs {
  const SmartCoachWorkoutsArgs();
}
