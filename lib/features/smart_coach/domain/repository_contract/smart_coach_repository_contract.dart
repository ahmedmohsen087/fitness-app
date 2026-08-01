import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import '../entities/chat_message_entity.dart';
import '../entities/chat_session_entity.dart';

abstract class SmartCoachRepositoryContract {
  Future<BaseResponse<ChatMessageEntity>> sendMessage({
    required String sessionId,
    required String messageContent,
    required ProfileEntity? profile,
    required String languageCode,
    String? imagePath,
    List<ChatMessageEntity> history = const [],
  });

  Future<BaseResponse<List<ChatSessionEntity>>> getChatHistory();

  Future<BaseResponse<void>> saveChatSession(ChatSessionEntity session);

  Future<BaseResponse<void>> deleteChatSession(String sessionId);
}
