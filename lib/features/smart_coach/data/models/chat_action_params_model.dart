import 'package:fitness_app/core/values/api_parameters.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/chat_action_params_entity.dart';

class ChatActionParamsModel {
  final String? mealId;
  final String? exerciseId;
  final String? workoutId;
  final String? muscleName;
  final String? image;

  const ChatActionParamsModel({
    this.mealId,
    this.exerciseId,
    this.workoutId,
    this.muscleName,
    this.image,
  });

  factory ChatActionParamsModel.fromJson(Map<String, dynamic> json) {
    String? extractString(String key, [List<String> altKeys = const []]) {
      if (json.containsKey(key) && json[key] != null) {
        return json[key].toString();
      }
      for (final k in altKeys) {
        if (json.containsKey(k) && json[k] != null) {
          return json[k].toString();
        }
      }
      return null;
    }

    return ChatActionParamsModel(
      mealId: extractString('mealId', [ApiParameters.mealId, 'meal_id', 'id']),
      exerciseId: extractString(
        ApiParameters.exerciseId,
        ['exercise_id', 'primeMoverMuscleId', 'muscleId', 'id'],
      ),
      workoutId: extractString(ApiParameters.workoutId, ['workout_id', 'id']),
      muscleName: extractString('muscleName', ['muscle_name', 'name']),
      image: extractString('image', ['image_url', 'imageUrl']),
    );
  }

  Map<String, dynamic> toJson() => {
        ApiParameters.mealId: mealId,
        ApiParameters.exerciseId: exerciseId,
        ApiParameters.workoutId: workoutId,
        'muscleName': muscleName,
        'image': image,
      };

  ChatActionParamsEntity toEntity() => ChatActionParamsEntity(
        mealId: mealId,
        exerciseId: exerciseId,
        workoutId: workoutId,
        muscleName: muscleName,
        image: image,
      );

  factory ChatActionParamsModel.fromEntity(ChatActionParamsEntity entity) {
    return ChatActionParamsModel(
      mealId: entity.mealId,
      exerciseId: entity.exerciseId,
      workoutId: entity.workoutId,
      muscleName: entity.muscleName,
      image: entity.image,
    );
  }
}

class ChatActionParamsModelAdapter extends TypeAdapter<ChatActionParamsModel> {
  @override
  final int typeId = 4;

  @override
  ChatActionParamsModel read(BinaryReader reader) {
    final hasMealId = reader.readBool();
    final mealId = hasMealId ? reader.readString() : null;
    final hasExerciseId = reader.readBool();
    final exerciseId = hasExerciseId ? reader.readString() : null;
    final hasWorkoutId = reader.readBool();
    final workoutId = hasWorkoutId ? reader.readString() : null;

    String? muscleName;
    String? image;

    try {
      final hasMuscleName = reader.readBool();
      if (hasMuscleName) muscleName = reader.readString();
      final hasImage = reader.readBool();
      if (hasImage) image = reader.readString();
    } catch (_) {}

    return ChatActionParamsModel(
      mealId: mealId,
      exerciseId: exerciseId,
      workoutId: workoutId,
      muscleName: muscleName,
      image: image,
    );
  }

  @override
  void write(BinaryWriter writer, ChatActionParamsModel obj) {
    writer.writeBool(obj.mealId != null);
    if (obj.mealId != null) writer.writeString(obj.mealId!);
    writer.writeBool(obj.exerciseId != null);
    if (obj.exerciseId != null) writer.writeString(obj.exerciseId!);
    writer.writeBool(obj.workoutId != null);
    if (obj.workoutId != null) writer.writeString(obj.workoutId!);
    writer.writeBool(obj.muscleName != null);
    if (obj.muscleName != null) writer.writeString(obj.muscleName!);
    writer.writeBool(obj.image != null);
    if (obj.image != null) writer.writeString(obj.image!);
  }
}
