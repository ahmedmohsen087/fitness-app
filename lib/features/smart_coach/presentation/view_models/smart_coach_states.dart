import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_session_entity.dart';
import '../../domain/entities/smart_coach_enums.dart';

class SmartCoachState extends Equatable {
  final SmartCoachViewMode viewMode;
  final String activeSessionId;
  final List<ChatMessageEntity> messages;
  final List<ChatSessionEntity> sessions;
  final String? attachedImagePath;
  final bool isLoadingAi;
  final String? errorMessage;

  const SmartCoachState({
    this.viewMode = SmartCoachViewMode.welcome,
    this.activeSessionId = '',
    this.messages = const [],
    this.sessions = const [],
    this.attachedImagePath,
    this.isLoadingAi = false,
    this.errorMessage,
  });

  SmartCoachState copyWith({
    SmartCoachViewMode? viewMode,
    String? activeSessionId,
    List<ChatMessageEntity>? messages,
    List<ChatSessionEntity>? sessions,
    String? attachedImagePath,
    bool? isLoadingAi,
    String? errorMessage,
  }) {
    return SmartCoachState(
      viewMode: viewMode ?? this.viewMode,
      activeSessionId: activeSessionId ?? this.activeSessionId,
      messages: messages ?? this.messages,
      sessions: sessions ?? this.sessions,
      attachedImagePath: attachedImagePath,
      isLoadingAi: isLoadingAi ?? this.isLoadingAi,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        viewMode,
        activeSessionId,
        messages,
        sessions,
        attachedImagePath,
        isLoadingAi,
        errorMessage,
      ];
}
