import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/fitness/domain/repository_contract/fitness_repository_contract.dart';
import 'package:fitness_app/features/food/domain/entities/category_food/category_food_entity.dart';
import 'package:fitness_app/features/food/domain/entities/category_food/recommendation_food_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food/meal_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food/meals_entity.dart';
import 'package:fitness_app/features/food/domain/repository_contract/food_repository_contract.dart';
import 'package:fitness_app/features/smart_coach/data/data_sources_contract/smart_coach_local_data_source_contract.dart';
import 'package:fitness_app/features/smart_coach/data/data_sources_contract/smart_coach_remote_data_source_contract.dart';
import 'package:fitness_app/features/smart_coach/data/models/chat_action_model.dart';
import 'package:fitness_app/features/smart_coach/data/models/chat_action_params_model.dart';
import 'package:fitness_app/features/smart_coach/data/models/chat_session_model.dart';
import 'package:fitness_app/features/smart_coach/data/models/ollama_chat_response_model.dart';
import 'package:fitness_app/features/smart_coach/data/repository_impl/smart_coach_repository_impl.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/chat_message_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/smart_coach_enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'smart_coach_repository_impl_test.mocks.dart';

@GenerateMocks([
  SmartCoachRemoteDataSourceContract,
  SmartCoachLocalDataSourceContract,
  FoodRepositoryContract,
  FitnessRepositoryContract,
])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<OllamaChatResponseModel>>(
      SuccessBaseResponse(
        data: const OllamaChatResponseModel(contentMessage: 'Test response'),
      ),
    );
    provideDummy<BaseResponse<List<ChatSessionModel>>>(
      SuccessBaseResponse(data: []),
    );
    provideDummy<BaseResponse<void>>(
      SuccessBaseResponse(data: null),
    );
    provideDummy<BaseResponse<RecommendationFoodEntity>>(
      SuccessBaseResponse(
        data: const RecommendationFoodEntity(categories: []),
      ),
    );
    provideDummy<BaseResponse<MealsEntity>>(
      SuccessBaseResponse(data: const MealsEntity(meals: [])),
    );
    provideDummy<BaseResponse<List<MuscleGroupEntity>>>(
      SuccessBaseResponse(data: []),
    );
    provideDummy<BaseResponse<List<MuscleEntity>>>(
      SuccessBaseResponse(data: []),
    );
  });

  late MockSmartCoachRemoteDataSourceContract mockRemoteDataSource;
  late MockSmartCoachLocalDataSourceContract mockLocalDataSource;
  late MockFoodRepositoryContract mockFoodRepository;
  late MockFitnessRepositoryContract mockFitnessRepository;
  late SmartCoachRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockSmartCoachRemoteDataSourceContract();
    mockLocalDataSource = MockSmartCoachLocalDataSourceContract();
    mockFoodRepository = MockFoodRepositoryContract();
    mockFitnessRepository = MockFitnessRepositoryContract();

    repository = SmartCoachRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockFoodRepository,
      mockFitnessRepository,
    );

    when(mockFoodRepository.getRecommendationFood()).thenAnswer(
      (_) async => SuccessBaseResponse(
        data: const RecommendationFoodEntity(
          categories: [CategoryFoodEntity(idCategory: '1', strCategory: 'Chicken', strCategoryThumb: '', strCategoryDescription: '')],
        ),
      ),
    );

    when(mockFoodRepository.getMealsByCategory(any)).thenAnswer(
      (_) async => SuccessBaseResponse(
        data: const MealsEntity(
          meals: [MealEntity(id: '52772', name: 'Teriyaki Chicken Casserole', thumbnail: '')],
        ),
      ),
    );

    when(mockFitnessRepository.getMuscleGroups()).thenAnswer(
      (_) async => SuccessBaseResponse(
        data: [const MuscleGroupEntity(id: 'g1', name: 'Chest')],
      ),
    );

    when(mockFitnessRepository.getMusclesByGroupId(any)).thenAnswer(
      (_) async => SuccessBaseResponse(
        data: [const MuscleEntity(id: '69d982ef85f6bfa972bf224e', name: 'Pectoralis Major', image: '')],
      ),
    );
  });

  test('getChatHistory returns mapped ChatSessionEntities on success', () async {
    final models = [
      ChatSessionModel(
        sessionId: 's1',
        title: 'Title',
        lastUpdated: DateTime(2026),
        messages: [],
      ),
    ];

    when(mockLocalDataSource.getChatSessions())
        .thenAnswer((_) async => SuccessBaseResponse(data: models));

    final result = await repository.getChatHistory();

    expect(result, isA<SuccessBaseResponse<List<dynamic>>>());
    final data = (result as SuccessBaseResponse).data;
    expect(data.length, 1);
    expect(data.first.sessionId, 's1');
  });

  test('sendMessage strips markdown external URLs and sanitizes exerciseId', () async {
    const remoteRes = OllamaChatResponseModel(
      contentMessage: 'Check out [Fitbit](https://fitbit.com/guide) for more info!',
      actionModel: ChatActionModel(
        typeString: 'navigateExercise',
        title: 'تمرين Pectoralis Major',
        params: ChatActionParamsModel(
          exerciseId: '69d982ef85f6bfa972bf224e, 69d982f085f6bfa972bf225a',
          muscleName: 'Pectoralis Major',
          image: '',
        ),
      ),
    );

    when(mockRemoteDataSource.sendChatCompletion(any))
        .thenAnswer((_) async => SuccessBaseResponse(data: remoteRes));

    final result = await repository.sendMessage(
      sessionId: 's1',
      messageContent: 'I want chest exercise',
      profile: null,
      languageCode: 'ar',
    );

    expect(result, isA<SuccessBaseResponse<ChatMessageEntity>>());
    final msg = (result as SuccessBaseResponse<ChatMessageEntity>).data;
    expect(msg.content.contains('fitbit.com'), false);
    expect(msg.action, isNotNull);
    expect(msg.action!.type, SmartCoachActionType.navigateExercise);
    expect(msg.action!.params.exerciseId, '69d982ef85f6bfa972bf224e');
  });
}
