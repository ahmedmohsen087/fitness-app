import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/use_cases/get_smart_coach_history_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'send_smart_coach_message_use_case_test.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<BaseResponse<List<ChatSessionEntity>>>(
      SuccessBaseResponse(data: []),
    );
  });

  late MockSmartCoachRepositoryContract mockRepository;
  late GetSmartCoachHistoryUseCase useCase;

  setUp(() {
    mockRepository = MockSmartCoachRepositoryContract();
    useCase = GetSmartCoachHistoryUseCase(mockRepository);
  });

  test('execute delegates to repository getChatHistory', () async {
    final expectedSessions = [
      ChatSessionEntity(
        sessionId: 's1',
        title: 'Session 1',
        lastUpdated: DateTime(2026),
        messages: [],
      ),
    ];

    when(mockRepository.getChatHistory())
        .thenAnswer((_) async => SuccessBaseResponse(data: expectedSessions));

    final result = await useCase.execute();

    expect(result, isA<SuccessBaseResponse<List<ChatSessionEntity>>>());
    expect((result as SuccessBaseResponse).data.length, 1);
    expect((result as SuccessBaseResponse).data.first.sessionId, 's1');
    verify(mockRepository.getChatHistory()).called(1);
  });
}
