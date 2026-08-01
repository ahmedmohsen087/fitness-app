import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:injectable/injectable.dart';
import '../entities/chat_message_entity.dart';
import '../repository_contract/smart_coach_repository_contract.dart';

@injectable
class SendSmartCoachMessageUseCase {
  final SmartCoachRepositoryContract _repository;

  const SendSmartCoachMessageUseCase(this._repository);

  Future<BaseResponse<ChatMessageEntity>> execute({
    required String sessionId,
    required String messageContent,
    required ProfileEntity? profile,
    required String languageCode,
    String? imagePath,
    List<ChatMessageEntity> history = const [],
  }) {
    return _repository.sendMessage(
      sessionId: sessionId,
      messageContent: messageContent,
      profile: profile,
      languageCode: languageCode,
      imagePath: imagePath,
      history: history,
    );
  }
}
