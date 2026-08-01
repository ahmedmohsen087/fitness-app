import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/use_cases/get_profile_data_usecase.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_view_model.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/chat_message_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/smart_coach_enums.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/use_cases/get_smart_coach_history_use_case.dart';
import 'package:fitness_app/features/smart_coach/domain/use_cases/save_smart_coach_session_use_case.dart';
import 'package:fitness_app/features/smart_coach/domain/use_cases/send_smart_coach_message_use_case.dart';
import 'package:fitness_app/features/smart_coach/presentation/view_models/smart_coach_events.dart';
import 'package:fitness_app/features/smart_coach/presentation/view_models/smart_coach_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'smart_coach_view_model_test.mocks.dart';

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

@GenerateMocks([
  SendSmartCoachMessageUseCase,
  GetSmartCoachHistoryUseCase,
  SaveSmartCoachSessionUseCase,
  GetProfileViewModel,
  GetProfileDataUseCase,
])
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
    provideDummy<BaseResponse<List<ChatSessionEntity>>>(
      SuccessBaseResponse(data: []),
    );
    provideDummy<BaseResponse<void>>(
      SuccessBaseResponse(data: null),
    );
    provideDummy<BaseResponse<ProfileEntity>>(
      SuccessBaseResponse(data: dummyProfile),
    );
  });

  late MockSendSmartCoachMessageUseCase mockSendMessageUseCase;
  late MockGetSmartCoachHistoryUseCase mockGetHistoryUseCase;
  late MockSaveSmartCoachSessionUseCase mockSaveSessionUseCase;
  late MockGetProfileViewModel mockProfileViewModel;
  late MockGetProfileDataUseCase mockGetProfileDataUseCase;
  late SmartCoachViewModel viewModel;

  setUp(() {
    mockSendMessageUseCase = MockSendSmartCoachMessageUseCase();
    mockGetHistoryUseCase = MockGetSmartCoachHistoryUseCase();
    mockSaveSessionUseCase = MockSaveSmartCoachSessionUseCase();
    mockProfileViewModel = MockGetProfileViewModel();
    mockGetProfileDataUseCase = MockGetProfileDataUseCase();

    when(mockProfileViewModel.state).thenReturn(
      GetProfileState(
        getProfileState: BaseState(
          data: dummyProfile,
        ),
      ),
    );

    when(mockGetProfileDataUseCase.getProfileData())
        .thenAnswer((_) async => SuccessBaseResponse(data: dummyProfile));

    viewModel = SmartCoachViewModel(
      mockSendMessageUseCase,
      mockGetHistoryUseCase,
      mockSaveSessionUseCase,
      mockProfileViewModel,
      mockGetProfileDataUseCase,
    );
  });

  tearDown(() {
    viewModel.close();
  });

  test('initial state has welcome view mode and empty messages', () {
    expect(viewModel.state.viewMode, SmartCoachViewMode.welcome);
    expect(viewModel.state.messages, isEmpty);
  });

  test('StartNewChatSessionEvent resets viewMode to welcome', () {
    viewModel.add(const StartNewChatSessionEvent());
    expect(viewModel.state.viewMode, SmartCoachViewMode.welcome);
  });

  test('SendSmartCoachMessageEvent updates messages and switches to activeChat', () async {
    final aiResponse = ChatMessageEntity(
      id: 'ai_1',
      content: 'I recommend Grilled Salmon',
      sender: MessageSender.ai,
      timestamp: DateTime(2026),
    );

    when(mockSendMessageUseCase.execute(
      sessionId: anyNamed('sessionId'),
      messageContent: anyNamed('messageContent'),
      profile: anyNamed('profile'),
      languageCode: anyNamed('languageCode'),
      imagePath: anyNamed('imagePath'),
      history: anyNamed('history'),
    )).thenAnswer((_) async => SuccessBaseResponse(data: aiResponse));

    when(mockSaveSessionUseCase.execute(any))
        .thenAnswer((_) async => SuccessBaseResponse(data: null));

    when(mockGetHistoryUseCase.execute())
        .thenAnswer((_) async => SuccessBaseResponse(data: []));

    viewModel.add(const SendSmartCoachMessageEvent(
      content: 'Suggest a meal',
      languageCode: 'en',
    ));

    await untilCalled(mockSendMessageUseCase.execute(
      sessionId: anyNamed('sessionId'),
      messageContent: anyNamed('messageContent'),
      profile: anyNamed('profile'),
      languageCode: anyNamed('languageCode'),
      imagePath: anyNamed('imagePath'),
      history: anyNamed('history'),
    ));

    await Future.delayed(Duration.zero);

    expect(viewModel.state.viewMode, SmartCoachViewMode.activeChat);
    expect(viewModel.state.messages.length, 2);
    expect(viewModel.state.messages.last.content, 'I recommend Grilled Salmon');
  });
}
