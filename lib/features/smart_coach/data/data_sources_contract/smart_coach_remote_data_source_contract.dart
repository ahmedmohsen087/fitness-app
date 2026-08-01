import 'package:fitness_app/config/base_response/base_response.dart';
import '../../api/request_models/ollama_chat_request_model.dart';
import '../models/ollama_chat_response_model.dart';

abstract class SmartCoachRemoteDataSourceContract {
  Future<BaseResponse<OllamaChatResponseModel>> sendChatCompletion(
    OllamaChatRequestModel request,
  );
}
