import 'package:equatable/equatable.dart';

abstract class SmartCoachEvent extends Equatable {
  const SmartCoachEvent();

  @override
  List<Object?> get props => [];
}

class LoadSmartCoachHistoryEvent extends SmartCoachEvent {
  const LoadSmartCoachHistoryEvent();
}

class StartNewChatSessionEvent extends SmartCoachEvent {
  const StartNewChatSessionEvent();
}

class SelectChatSessionEvent extends SmartCoachEvent {
  final String sessionId;

  const SelectChatSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class SendSmartCoachMessageEvent extends SmartCoachEvent {
  final String content;
  final String? imagePath;
  final String languageCode;

  const SendSmartCoachMessageEvent({
    required this.content,
    required this.languageCode,
    this.imagePath,
  });

  @override
  List<Object?> get props => [content, imagePath, languageCode];
}

class ClearAttachedImageEvent extends SmartCoachEvent {
  const ClearAttachedImageEvent();
}

class AttachImageEvent extends SmartCoachEvent {
  final String imagePath;

  const AttachImageEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}
