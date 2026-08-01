import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources_contract/smart_coach_remote_data_source_contract.dart';
import '../../data/models/ollama_chat_response_model.dart';
import '../api_client/smart_coach_api_client.dart';
import '../request_models/ollama_chat_request_model.dart';

@Injectable(as: SmartCoachRemoteDataSourceContract)
class SmartCoachRemoteDataSourceImpl
    implements SmartCoachRemoteDataSourceContract {
  final SmartCoachApiClient _apiClient;

  SmartCoachRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<OllamaChatResponseModel>> sendChatCompletion(
    OllamaChatRequestModel request,
  ) async {
    try {
      final model = await _apiClient.sendChatCompletion(request);
      return SuccessBaseResponse(data: model);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: e.toString());
    }
  }
}
