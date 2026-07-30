import '../../data/models/difficulty_level_model.dart';
import '../../data/models/exercise_model.dart';
import '../../data/models/muscle_group_model.dart';
import '../../data/models/muscle_model.dart';
import '../entities/difficulty_level_entity.dart';
import '../entities/exercise_entity.dart';
import '../entities/muscle_entity.dart';
import '../entities/muscle_group_entity.dart';

extension MuscleGroupModelMapper on MuscleGroupModel {
  MuscleGroupEntity toEntity() {
    return MuscleGroupEntity(id: id ?? '', name: name ?? '');
  }
}

extension MuscleModelMapper on MuscleModel {
  MuscleEntity toEntity() {
    return MuscleEntity(id: id ?? '', name: name ?? '', image: image ?? '');
  }
}

extension DifficultyLevelModelMapper on DifficultyLevelModel {
  DifficultyLevelEntity toEntity() {
    return DifficultyLevelEntity(id: id ?? '', name: name ?? '');
  }
}

extension ExerciseModelMapper on ExerciseModel {
  ExerciseEntity toEntity() {
    final video =
        shortYoutubeDemonstrationLink ?? inDepthYoutubeExplanationLink ?? '';

    return ExerciseEntity(
      id: id ?? '',
      exercise: exercise ?? '',
      difficultyLevel: difficultyLevel ?? '',
      targetMuscleGroup: targetMuscleGroup ?? '',
      primeMoverMuscle: primeMoverMuscle ?? '',
      primaryEquipment: primaryEquipment ?? '',
      videoUrl: video,
    );
  }
}
