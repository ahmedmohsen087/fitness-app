import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/chat_message_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/smart_coach_enums.dart';
import 'package:fitness_app/features/smart_coach/domain/repository_contract/smart_coach_repository_contract.dart';
import 'package:fitness_app/features/smart_coach/domain/use_cases/send_smart_coach_message_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'send_smart_coach_message_use_case_test.mocks.dart';

@GenerateMocks([SmartCoachRepositoryContract])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<ChatMessageEntity>>(
      SuccessBaseResponse(
        data: ChatMessageEntity(
          id: 'dummy',
          content: '',
          sender: MessageSender.ai,
          timestamp: DateTime(2026),
        ),
      ),
    );
  });

  late MockSmartCoachRepositoryContract mockRepository;
  late SendSmartCoachMessageUseCase useCase;

  final dummyProfile = ProfileEntity(
    id: '1',
    firstName: 'Abdelrahaman',
    lastName: 'shalaan',
    email: 'abdelrahaman@gmail.com',
    gender: 'male',
    age: 23,
    weight: 86,
    height: 178,
    activityLevel: 'level3',
    goal: 'Get fitter',
    photo: '',
    createdAt: DateTime(2026),
  );

  setUp(() {
    mockRepository = MockSmartCoachRepositoryContract();
    useCase = SendSmartCoachMessageUseCase(mockRepository);
  });

  test('execute delegates to repository sendMessage', () async {
    final expectedMsg = ChatMessageEntity(
      id: '1',
      content: 'Healthy meal recommendation',
      sender: MessageSender.ai,
      timestamp: DateTime(2026),
    );

    when(mockRepository.sendMessage(
      sessionId: anyNamed('sessionId'),
      messageContent: anyNamed('messageContent'),
      profile: anyNamed('profile'),
      languageCode: anyNamed('languageCode'),
      imagePath: anyNamed('imagePath'),
      history: anyNamed('history'),
    )).thenAnswer((_) async => SuccessBaseResponse(data: expectedMsg));

    final result = await useCase.execute(
      sessionId: 'session_1',
      messageContent: 'Suggest a meal',
      profile: dummyProfile,
      languageCode: 'en',
    );

    expect(result, isA<SuccessBaseResponse<ChatMessageEntity>>());
    expect((result as SuccessBaseResponse).data.content, 'Healthy meal recommendation');
    verify(mockRepository.sendMessage(
      sessionId: 'session_1',
      messageContent: 'Suggest a meal',
      profile: dummyProfile,
      languageCode: 'en',
      imagePath: null,
      history: const [],
    )).called(1);
  });
}
