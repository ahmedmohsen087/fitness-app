import 'package:equatable/equatable.dart';
import 'chat_message_entity.dart';

class ChatSessionEntity extends Equatable {
  final String sessionId;
  final String title;
  final DateTime lastUpdated;
  final List<ChatMessageEntity> messages;

  const ChatSessionEntity({
    required this.sessionId,
    required this.title,
    required this.lastUpdated,
    required this.messages,
  });

  ChatSessionEntity copyWith({
    String? sessionId,
    String? title,
    DateTime? lastUpdated,
    List<ChatMessageEntity>? messages,
  }) {
    return ChatSessionEntity(
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [sessionId, title, lastUpdated, messages];
}
