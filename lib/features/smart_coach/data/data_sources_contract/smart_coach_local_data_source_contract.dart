import 'package:fitness_app/config/base_response/base_response.dart';
import '../models/chat_session_model.dart';

abstract class SmartCoachLocalDataSourceContract {
  Future<BaseResponse<List<ChatSessionModel>>> getChatSessions();

  Future<BaseResponse<void>> saveChatSession(ChatSessionModel session);

  Future<BaseResponse<void>> deleteChatSession(String sessionId);
}
