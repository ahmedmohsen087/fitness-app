import 'package:equatable/equatable.dart';
import 'chat_action_entity.dart';
import 'smart_coach_enums.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;
  final String? imagePath;
  final ChatActionEntity? action;
  final SmartCoachMessageStatus status;

  const ChatMessageEntity({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.imagePath,
    this.action,
    this.status = SmartCoachMessageStatus.sent,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? content,
    MessageSender? sender,
    DateTime? timestamp,
    String? imagePath,
    ChatActionEntity? action,
    SmartCoachMessageStatus? status,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      imagePath: imagePath ?? this.imagePath,
      action: action ?? this.action,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        content,
        sender,
        timestamp,
        imagePath,
        action,
        status,
      ];
}
