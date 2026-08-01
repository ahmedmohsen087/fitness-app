import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/smart_coach/api/api_client/smart_coach_api_client.dart';
import 'package:fitness_app/features/smart_coach/api/data_sources_impl/smart_coach_remote_data_source_impl.dart';
import 'package:fitness_app/features/smart_coach/api/request_models/ollama_chat_request_model.dart';
import 'package:fitness_app/features/smart_coach/data/models/ollama_chat_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'smart_coach_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([SmartCoachApiClient])
void main() {
  late MockSmartCoachApiClient mockApiClient;
  late SmartCoachRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockSmartCoachApiClient();
    dataSource = SmartCoachRemoteDataSourceImpl(mockApiClient);
  });

  test('sendChatCompletion returns SuccessBaseResponse on success', () async {
    final request = OllamaChatRequestModel(messages: [
      const OllamaChatMessagePayload(role: 'user', content: 'hello'),
    ]);

    final expectedModel = OllamaChatResponseModel(contentMessage: 'Hi athlete!');

    when(mockApiClient.sendChatCompletion(any))
        .thenAnswer((_) async => expectedModel);

    final result = await dataSource.sendChatCompletion(request);

    expect(result, isA<SuccessBaseResponse>());
    expect((result as SuccessBaseResponse).data.contentMessage, 'Hi athlete!');
  });

  test('sendChatCompletion returns ErrorBaseResponse when apiClient throws', () async {
    final request = OllamaChatRequestModel(messages: []);

    when(mockApiClient.sendChatCompletion(any)).thenThrow(Exception('Network error'));

    final result = await dataSource.sendChatCompletion(request);

    expect(result, isA<ErrorBaseResponse>());
    expect((result as ErrorBaseResponse).errorMessage, contains('Network error'));
  });
}
