import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/use_cases/save_smart_coach_session_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'send_smart_coach_message_use_case_test.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<BaseResponse<void>>(
      SuccessBaseResponse(data: null),
    );
  });

  late MockSmartCoachRepositoryContract mockRepository;
  late SaveSmartCoachSessionUseCase useCase;

  setUp(() {
    mockRepository = MockSmartCoachRepositoryContract();
    useCase = SaveSmartCoachSessionUseCase(mockRepository);
  });

  test('execute delegates to repository saveChatSession', () async {
    final session = ChatSessionEntity(
      sessionId: 's1',
      title: 'Session 1',
      lastUpdated: DateTime(2026),
      messages: [],
    );

    when(mockRepository.saveChatSession(session))
        .thenAnswer((_) async => SuccessBaseResponse(data: null));

    final result = await useCase.execute(session);

    expect(result, isA<SuccessBaseResponse<void>>());
    verify(mockRepository.saveChatSession(session)).called(1);
  });
}
