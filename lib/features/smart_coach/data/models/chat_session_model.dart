import 'package:hive/hive.dart';
import '../../domain/entities/chat_session_entity.dart';
import 'chat_message_model.dart';

class ChatSessionModel {
  final String sessionId;
  final String title;
  final DateTime lastUpdated;
  final List<ChatMessageModel> messages;

  const ChatSessionModel({
    required this.sessionId,
    required this.title,
    required this.lastUpdated,
    required this.messages,
  });

  factory ChatSessionModel.fromEntity(ChatSessionEntity entity) {
    return ChatSessionModel(
      sessionId: entity.sessionId,
      title: entity.title,
      lastUpdated: entity.lastUpdated,
      messages: entity.messages.map(ChatMessageModel.fromEntity).toList(),
    );
  }

  ChatSessionEntity toEntity() {
    return ChatSessionEntity(
      sessionId: sessionId,
      title: title,
      lastUpdated: lastUpdated,
      messages: messages.map((m) => m.toEntity()).toList(),
    );
  }
}

class ChatSessionModelAdapter extends TypeAdapter<ChatSessionModel> {
  @override
  final int typeId = 3;

  @override
  ChatSessionModel read(BinaryReader reader) {
    final sessionId = reader.readString();
    final title = reader.readString();
    final lastUpdated = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final rawList = reader.readList();
    final messages = rawList.cast<ChatMessageModel>();
    return ChatSessionModel(
      sessionId: sessionId,
      title: title,
      lastUpdated: lastUpdated,
      messages: messages,
    );
  }

  @override
  void write(BinaryWriter writer, ChatSessionModel obj) {
    writer.writeString(obj.sessionId);
    writer.writeString(obj.title);
    writer.writeInt(obj.lastUpdated.millisecondsSinceEpoch);
    writer.writeList(obj.messages);
  }
}
