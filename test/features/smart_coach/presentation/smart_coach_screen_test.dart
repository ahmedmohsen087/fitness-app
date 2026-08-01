import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/use_cases/get_profile_data_usecase.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_view_model.dart';
import 'package:fitness_app/features/section_app/view_model/section_tab_cubit.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/chat_message_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/smart_coach_enums.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/chat_session_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/use_cases/get_smart_coach_history_use_case.dart';
import 'package:fitness_app/features/smart_coach/domain/use_cases/save_smart_coach_session_use_case.dart';
import 'package:fitness_app/features/smart_coach/domain/use_cases/send_smart_coach_message_use_case.dart';
import 'package:fitness_app/features/smart_coach/presentation/screens/smart_coach_screen.dart';
import 'package:fitness_app/features/smart_coach/presentation/view_models/smart_coach_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'smart_coach_screen_test.mocks.dart';

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

  setUp(() {
    mockSendMessageUseCase = MockSendSmartCoachMessageUseCase();
    mockGetHistoryUseCase = MockGetSmartCoachHistoryUseCase();
    mockSaveSessionUseCase = MockSaveSmartCoachSessionUseCase();
    mockProfileViewModel = MockGetProfileViewModel();
    mockGetProfileDataUseCase = MockGetProfileDataUseCase();

    when(mockGetHistoryUseCase.execute())
        .thenAnswer((_) async => SuccessBaseResponse(data: []));

    when(mockProfileViewModel.state).thenReturn(
      GetProfileState(
        getProfileState: BaseState(
          data: dummyProfile,
        ),
      ),
    );

    when(mockGetProfileDataUseCase.getProfileData())
        .thenAnswer((_) async => SuccessBaseResponse(data: dummyProfile));

    when(mockProfileViewModel.stream).thenAnswer(
      (_) => const Stream.empty(),
    );

    if (getIt.isRegistered<SmartCoachViewModel>()) {
      getIt.unregister<SmartCoachViewModel>();
    }

    getIt.registerFactory<SmartCoachViewModel>(
      () => SmartCoachViewModel(
        mockSendMessageUseCase,
        mockGetHistoryUseCase,
        mockSaveSessionUseCase,
        mockProfileViewModel,
        mockGetProfileDataUseCase,
      ),
    );
  });

  testWidgets('renders SmartCoachScreen in welcome state correctly', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<GetProfileViewModel>.value(
              value: mockProfileViewModel,
            ),
            BlocProvider(create: (_) => SectionTabCubit()),
          ],
          child: const SmartCoachScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(SmartCoachScreen), findsOneWidget);
  });
}
