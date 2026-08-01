import 'package:fitness_app/core/values/api_parameters.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/chat_action_entity.dart';
import '../../domain/entities/smart_coach_enums.dart';
import 'chat_action_params_model.dart';

class ChatActionModel {
  final String typeString;
  final String title;
  final ChatActionParamsModel params;

  const ChatActionModel({
    required this.typeString,
    required this.title,
    required this.params,
  });

  factory ChatActionModel.fromEntity(ChatActionEntity entity) {
    return ChatActionModel(
      typeString: entity.type.name,
      title: entity.title,
      params: ChatActionParamsModel.fromEntity(entity.params),
    );
  }

  ChatActionEntity toEntity() {
    final normalized = typeString.replaceAll('_', '').toLowerCase();
    final type = SmartCoachActionType.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized || e.name == typeString,
      orElse: () => SmartCoachActionType.none,
    );
    return ChatActionEntity(
      type: type,
      title: title,
      params: params.toEntity(),
    );
  }

  factory ChatActionModel.fromJson(Map<String, dynamic> json) {
    final rawParams = json[ApiParameters.params];
    final paramsModel = rawParams is Map<String, dynamic>
        ? ChatActionParamsModel.fromJson(rawParams)
        : const ChatActionParamsModel();

    return ChatActionModel(
      typeString: json[ApiParameters.type] as String? ?? 'none',
      title: json[ApiParameters.title] as String? ?? '',
      params: paramsModel,
    );
  }

  Map<String, dynamic> toJson() => {
        ApiParameters.type: typeString,
        ApiParameters.title: title,
        ApiParameters.params: params.toJson(),
      };
}

class ChatActionModelAdapter extends TypeAdapter<ChatActionModel> {
  @override
  final int typeId = 2;

  @override
  ChatActionModel read(BinaryReader reader) {
    final typeString = reader.readString();
    final title = reader.readString();
    final params = reader.read() as ChatActionParamsModel;
    return ChatActionModel(
      typeString: typeString,
      title: title,
      params: params,
    );
  }

  @override
  void write(BinaryWriter writer, ChatActionModel obj) {
    writer.writeString(obj.typeString);
    writer.writeString(obj.title);
    writer.write(obj.params);
  }
}
