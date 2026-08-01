import 'package:dio/dio.dart';
import 'package:fitness_app/core/values/api_endpoints.dart';
import 'package:fitness_app/core/values/api_parameters.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../data/models/ollama_chat_response_model.dart';
import '../request_models/ollama_chat_request_model.dart';

part 'smart_coach_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: ApiEndpoints.ollamaBaseUrl)
abstract class SmartCoachApiClient {
  @factoryMethod
  factory SmartCoachApiClient(Dio dio) = _SmartCoachApiClient;

  @POST(ApiEndpoints.ollamaChat)
  @Extra({ApiParameters.requiresAuth: false})
  Future<OllamaChatResponseModel> sendChatCompletion(
    @Body() OllamaChatRequestModel request,
  );
}
