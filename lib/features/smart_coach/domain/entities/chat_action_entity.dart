import 'package:equatable/equatable.dart';
import 'chat_action_params_entity.dart';
import 'smart_coach_enums.dart';

class ChatActionEntity extends Equatable {
  final SmartCoachActionType type;
  final String title;
  final ChatActionParamsEntity params;

  const ChatActionEntity({
    required this.type,
    required this.title,
    required this.params,
  });

  @override
  List<Object?> get props => [type, title, params];
}
