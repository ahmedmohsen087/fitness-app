import 'package:hive/hive.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/smart_coach_enums.dart';
import 'chat_action_model.dart';

class ChatMessageModel {
  final String id;
  final String content;
  final String senderString;
  final DateTime timestamp;
  final String? imagePath;
  final ChatActionModel? action;
  final String statusString;

  const ChatMessageModel({
    required this.id,
    required this.content,
    required this.senderString,
    required this.timestamp,
    this.imagePath,
    this.action,
    this.statusString = 'sent',
  });

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      content: entity.content,
      senderString: entity.sender.name,
      timestamp: entity.timestamp,
      imagePath: entity.imagePath,
      action: entity.action != null
          ? ChatActionModel.fromEntity(entity.action!)
          : null,
      statusString: entity.status.name,
    );
  }

  ChatMessageEntity toEntity() {
    final sender = MessageSender.values.firstWhere(
      (e) => e.name == senderString,
      orElse: () => MessageSender.ai,
    );
    final status = SmartCoachMessageStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => SmartCoachMessageStatus.sent,
    );
    return ChatMessageEntity(
      id: id,
      content: content,
      sender: sender,
      timestamp: timestamp,
      imagePath: imagePath,
      action: action?.toEntity(),
      status: status,
    );
  }
}

class ChatMessageModelAdapter extends TypeAdapter<ChatMessageModel> {
  @override
  final int typeId = 1;

  @override
  ChatMessageModel read(BinaryReader reader) {
    final id = reader.readString();
    final content = reader.readString();
    final senderString = reader.readString();
    final timestamp = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final hasImagePath = reader.readBool();
    final imagePath = hasImagePath ? reader.readString() : null;
    final hasAction = reader.readBool();
    final action = hasAction ? reader.read() as ChatActionModel : null;
    final statusString = reader.readString();
    return ChatMessageModel(
      id: id,
      content: content,
      senderString: senderString,
      timestamp: timestamp,
      imagePath: imagePath,
      action: action,
      statusString: statusString,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessageModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.content);
    writer.writeString(obj.senderString);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeBool(obj.imagePath != null);
    if (obj.imagePath != null) writer.writeString(obj.imagePath!);
    writer.writeBool(obj.action != null);
    if (obj.action != null) writer.write(obj.action!);
    writer.writeString(obj.statusString);
  }
}
