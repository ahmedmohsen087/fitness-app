import 'dart:convert';
import 'dart:io';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/fitness/domain/repository_contract/fitness_repository_contract.dart';
import 'package:fitness_app/features/food/domain/entities/category_food/recommendation_food_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food/meals_entity.dart';
import 'package:fitness_app/features/food/domain/repository_contract/food_repository_contract.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/chat_action_entity.dart';
import '../../domain/entities/chat_action_params_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_session_entity.dart';
import '../../domain/entities/smart_coach_enums.dart';
import '../../domain/repository_contract/smart_coach_repository_contract.dart';
import '../data_sources_contract/smart_coach_local_data_source_contract.dart';
import '../data_sources_contract/smart_coach_remote_data_source_contract.dart';
import '../models/chat_session_model.dart';
import '../../api/request_models/ollama_chat_request_model.dart';

class _PromptResult {
  final String systemPrompt;
  final Map<String, String> catalogMeals;
  final Map<String, MuscleEntity> catalogMuscles;

  const _PromptResult(
    this.systemPrompt,
    this.catalogMeals,
    this.catalogMuscles,
  );
}

@Injectable(as: SmartCoachRepositoryContract)
class SmartCoachRepositoryImpl implements SmartCoachRepositoryContract {
  final SmartCoachRemoteDataSourceContract _remoteDataSource;
  final SmartCoachLocalDataSourceContract _localDataSource;
  final FoodRepositoryContract _foodRepository;
  final FitnessRepositoryContract _fitnessRepository;

  static final RegExp _markdownUrlRegex = RegExp(r'\[https?://[^\]]+\]\([^)]+\)');
  static final RegExp _rawUrlRegex = RegExp(r'https?://\S+');
  static final RegExp _objectIdRegex = RegExp(r'[a-fA-F0-9]{24}');

  SmartCoachRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._foodRepository,
    this._fitnessRepository,
  );

  @override
  Future<BaseResponse<ChatMessageEntity>> sendMessage({
    required String sessionId,
    required String messageContent,
    required ProfileEntity? profile,
    required String languageCode,
    String? imagePath,
    List<ChatMessageEntity> history = const [],
  }) async {
    final promptResult = await _buildSystemPrompt(profile, languageCode);
    final payloadMessages = _buildPayloadMessages(
      systemPrompt: promptResult.systemPrompt,
      history: history,
      currentContent: messageContent,
      imagePath: imagePath,
    );

    final request = OllamaChatRequestModel(messages: payloadMessages);
    final response = await _remoteDataSource.sendChatCompletion(request);

    return _handleRemoteResponse(
      response,
      promptResult.catalogMeals,
      promptResult.catalogMuscles,
    );
  }

  @override
  Future<BaseResponse<List<ChatSessionEntity>>> getChatHistory() async {
    final result = await _localDataSource.getChatSessions();
    if (result is SuccessBaseResponse<List<ChatSessionModel>>) {
      final entities = result.data.map((m) => m.toEntity()).toList();
      return SuccessBaseResponse(data: entities);
    } else if (result is ErrorBaseResponse<List<ChatSessionModel>>) {
      return ErrorBaseResponse(errorMessage: result.errorMessage);
    }
    return ErrorBaseResponse(errorMessage: 'Failed to load chat history');
  }

  @override
  Future<BaseResponse<void>> saveChatSession(ChatSessionEntity session) {
    final model = ChatSessionModel.fromEntity(session);
    return _localDataSource.saveChatSession(model);
  }

  @override
  Future<BaseResponse<void>> deleteChatSession(String sessionId) {
    return _localDataSource.deleteChatSession(sessionId);
  }

  Future<_PromptResult> _buildSystemPrompt(
    ProfileEntity? profile,
    String languageCode,
  ) async {
    final isAr = languageCode == 'ar';

    final name = profile?.firstName ?? '';
    final gender = profile?.gender ?? '';
    final age = profile?.age != null ? '${profile!.age}' : '';
    final weight = profile?.weight != null ? '${profile!.weight}kg' : '';
    final height = profile?.height != null ? '${profile!.height}cm' : '';
    final goal = profile?.goal ?? '';

    final langInstruction = isAr
        ? 'Respond strictly in natural ARABIC (باللغة العربية).'
        : 'Respond strictly in natural ENGLISH.';

    final profileDetails = [
      if (name.isNotEmpty) 'Name: $name',
      if (gender.isNotEmpty) 'Gender: $gender',
      if (age.isNotEmpty) 'Age: $age',
      if (weight.isNotEmpty) 'Weight: $weight',
      if (height.isNotEmpty) 'Height: $height',
      if (goal.isNotEmpty) 'Goal: $goal',
    ].join(', ');

    final mealBuffer = StringBuffer();
    final muscleBuffer = StringBuffer();
    final catalogMealsMap = <String, String>{};
    final catalogMusclesMap = <String, MuscleEntity>{};

    try {
      final recRes = await _foodRepository.getRecommendationFood();
      if (recRes is SuccessBaseResponse<RecommendationFoodEntity>) {
        final categoryNames = recRes.data.categories
            .map((c) => c.strCategory)
            .where((name) => name.isNotEmpty)
            .toList();

        final responses = await Future.wait(
          categoryNames.take(6).map((c) => _foodRepository.getMealsByCategory(c)),
        );
        for (final res in responses) {
          if (res is SuccessBaseResponse<MealsEntity>) {
            for (final m in res.data.meals.take(4)) {
              if (m.id.isNotEmpty && m.name.isNotEmpty) {
                mealBuffer.writeln('- Meal ID "${m.id}": ${m.name}');
                catalogMealsMap[m.id] = m.name;
              }
            }
          }
        }
      }
    } catch (_) {}

    try {
      final groupsRes = await _fitnessRepository.getMuscleGroups();
      if (groupsRes is SuccessBaseResponse<List<MuscleGroupEntity>>) {
        final groups = groupsRes.data;
        final musclesResponses = await Future.wait(
          groups.take(6).map((g) => _fitnessRepository.getMusclesByGroupId(g.id)),
        );

        for (int i = 0; i < musclesResponses.length; i++) {
          final groupName = groups[i].name;
          final res = musclesResponses[i];
          if (res is SuccessBaseResponse<List<MuscleEntity>>) {
            for (final m in res.data) {
              if (m.id.isNotEmpty && m.name.isNotEmpty) {
                muscleBuffer.writeln(
                  '- Muscle Group "$groupName" -> Muscle ID "${m.id}": ${m.name}${m.image.isNotEmpty ? ' (Image: ${m.image})' : ''}',
                );
                catalogMusclesMap[m.id] = m;
              }
            }
          }
        }
      }
    } catch (_) {}

    final promptText =
        'You are Smart Coach, an expert AI fitness & nutrition coach in our Fitness App. '
        '${profileDetails.isNotEmpty ? "User Profile Data: $profileDetails." : ""} '
        '$langInstruction '
        'FORBIDDEN: NEVER output external website URLs or http/https links. '
        'CRITICAL RULE FOR EXERCISE ACTIONS: exerciseId MUST BE A SINGLE 24-character hexadecimal ID (e.g. 69d982ef85f6bfa972bf224e). NEVER COMBINE OR JOIN MULTIPLE IDs WITH COMMAS OR SPACES. '
        'GUIDELINES: '
        '1. For general chat (asking weight, height, greetings, general advice), answer naturally in plain text ONLY. DO NOT append any action or JSON. '
        '2. ONLY IF the user explicitly asks for a meal or recipe recommendation, analyze their request intelligently, select a matching meal from the live catalog below, explain why naturally, and append a JSON action at the end: '
        '{"action": {"type": "navigateFoodDetails", "title": "<Meal Name>", "params": {"mealId": "<Meal ID>"}}} '
        '3. ONLY IF the user explicitly asks for exercise suggestions, workout routines, or to view exercises (e.g. "انقلني لصفحة التمارين"), analyze their request intelligently, select a SINGLE matching muscle from the live muscles catalog below, explain the exercise/routine naturally, and append a JSON action at the end: '
        '{"action": {"type": "navigateExercise", "title": "تمرين <Muscle Name>", "params": {"exerciseId": "<SINGLE Muscle ID>", "muscleName": "<Muscle Name>", "image": "<Muscle Image URL>"}}} '
        'LIVE APP MEALS CATALOG FROM API: '
        '${mealBuffer.toString()} '
        'LIVE APP MUSCLES CATALOG FROM API: '
        '${muscleBuffer.toString()}';

    return _PromptResult(promptText, catalogMealsMap, catalogMusclesMap);
  }

  List<OllamaChatMessagePayload> _buildPayloadMessages({
    required String systemPrompt,
    required List<ChatMessageEntity> history,
    required String currentContent,
    String? imagePath,
  }) {
    final list = <OllamaChatMessagePayload>[
      OllamaChatMessagePayload(role: 'system', content: systemPrompt),
    ];

    final recentHistory = history.length > 6
        ? history.sublist(history.length - 6)
        : history;

    for (final msg in recentHistory) {
      list.add(
        OllamaChatMessagePayload(
          role: msg.sender == MessageSender.user ? 'user' : 'assistant',
          content: msg.content,
        ),
      );
    }

    List<String>? base64Images;
    if (imagePath != null && imagePath.isNotEmpty) {
      try {
        final bytes = File(imagePath).readAsBytesSync();
        base64Images = [base64Encode(bytes)];
      } catch (_) {}
    }

    list.add(
      OllamaChatMessagePayload(
        role: 'user',
        content: currentContent,
        images: base64Images,
      ),
    );

    return list;
  }

  BaseResponse<ChatMessageEntity> _handleRemoteResponse(
    BaseResponse<dynamic> response,
    Map<String, String> catalogMeals,
    Map<String, MuscleEntity> catalogMuscles,
  ) {
    if (response is SuccessBaseResponse) {
      final resModel = response.data;
      var content = resModel.contentMessage as String;
      ChatActionEntity? actionEntity = resModel.actionModel?.toEntity();

      content = content
          .replaceAll(_markdownUrlRegex, '')
          .replaceAll(_rawUrlRegex, '')
          .trim();

      if (actionEntity == null) {
        final contentLower = content.toLowerCase();
        if (catalogMeals.isNotEmpty) {
          for (final entry in catalogMeals.entries) {
            final mealId = entry.key;
            final mealName = entry.value;
            if (contentLower.contains(mealId.toLowerCase()) ||
                contentLower.contains(mealName.toLowerCase())) {
              actionEntity = ChatActionEntity(
                type: SmartCoachActionType.navigateFoodDetails,
                title: mealName,
                params: ChatActionParamsEntity(mealId: mealId),
              );
              break;
            }
          }
        }
        if (actionEntity == null && catalogMuscles.isNotEmpty) {
          for (final entry in catalogMuscles.entries) {
            final muscle = entry.value;
            if (contentLower.contains(muscle.id.toLowerCase()) ||
                contentLower.contains(muscle.name.toLowerCase())) {
              actionEntity = ChatActionEntity(
                type: SmartCoachActionType.navigateExercise,
                title: 'تمرين ${muscle.name}',
                params: ChatActionParamsEntity(
                  exerciseId: muscle.id,
                  muscleName: muscle.name,
                  image: muscle.image,
                ),
              );
              break;
            }
          }
        }
        if (actionEntity == null &&
            catalogMuscles.isNotEmpty &&
            (contentLower.contains('تمرين') ||
                contentLower.contains('تمارين') ||
                contentLower.contains('workout') ||
                contentLower.contains('exercise') ||
                contentLower.contains('انقلني') ||
                contentLower.contains('ريفرنس'))) {
          final targetMuscle = catalogMuscles.values.first;
          actionEntity = ChatActionEntity(
            type: SmartCoachActionType.navigateExercise,
            title: 'تمرين ${targetMuscle.name}',
            params: ChatActionParamsEntity(
              exerciseId: targetMuscle.id,
              muscleName: targetMuscle.name,
              image: targetMuscle.image,
            ),
          );
        }
      }

      if (actionEntity != null &&
          actionEntity.type == SmartCoachActionType.navigateExercise) {
        final rawId = actionEntity.params.exerciseId ?? '';
        final match = _objectIdRegex.firstMatch(rawId);
        if (match != null) {
          final cleanId = match.group(0)!;
          actionEntity = ChatActionEntity(
            type: actionEntity.type,
            title: actionEntity.title,
            params: ChatActionParamsEntity(
              exerciseId: cleanId,
              muscleName: actionEntity.params.muscleName,
              image: actionEntity.params.image,
            ),
          );
        }
      }

      final entity = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        action: actionEntity,
      );
      return SuccessBaseResponse(data: entity);
    } else if (response is ErrorBaseResponse) {
      return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
    return ErrorBaseResponse(errorMessage: 'Unknown error occurred');
  }
}
