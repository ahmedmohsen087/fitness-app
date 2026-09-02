import 'dart:convert';
import 'dart:io';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/fitness/domain/repository_contract/fitness_repository_contract.dart';
import 'package:fitness_app/features/food/domain/entities/category_food/recommendation_food_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food/meal_entity.dart';
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

  static const Map<String, String> _keywordToCategory = {
    'سمك': 'Seafood',
    'سلمون': 'Seafood',
    'سالمون': 'Seafood',
    'جمبري': 'Seafood',
    'بحرية': 'Seafood',
    'سي فود': 'Seafood',
    'تونة': 'Seafood',
    'سبيط': 'Seafood',
    'روبيان': 'Seafood',
    'seafood': 'Seafood',
    'fish': 'Seafood',
    'salmon': 'Seafood',
    'shrimp': 'Seafood',
    'prawn': 'Seafood',
    'tuna': 'Seafood',
    'بقري': 'Beef',
    'استيك': 'Beef',
    'ستيك': 'Beef',
    'كفتة': 'Beef',
    'برجر': 'Beef',
    'beef': 'Beef',
    'steak': 'Beef',
    'meatball': 'Beef',
    'ضاني': 'Lamb',
    'خروف': 'Lamb',
    'ضأن': 'Lamb',
    'lamb': 'Lamb',
    'دجاج': 'Chicken',
    'فراخ': 'Chicken',
    'طيور': 'Chicken',
    'chicken': 'Chicken',
    'باستا': 'Pasta',
    'مكرونة': 'Pasta',
    'pasta': 'Pasta',
    'نباتي': 'Vegetarian',
    'خضار': 'Vegetarian',
    'سلطة': 'Vegetarian',
    'vegetarian': 'Vegetarian',
    'vegan': 'Vegetarian',
    'حلو': 'Dessert',
    'حلويات': 'Dessert',
    'كيك': 'Dessert',
    'dessert': 'Dessert',
    'cake': 'Dessert',
    'لحم': 'Beef',
    'meat': 'Beef',
  };

  static const Map<String, List<String>> _keywordToTerms = {
    'سلمون': ['salmon'],
    'سالمون': ['salmon'],
    'salmon': ['salmon'],
    'استيك': ['steak', 'roast', 'brisket', 'beef'],
    'ستيك': ['steak', 'roast', 'brisket', 'beef'],
    'steak': ['steak', 'roast', 'brisket', 'beef'],
    'جمبري': ['shrimp', 'prawn', 'gambas'],
    'روبيان': ['shrimp', 'prawn', 'gambas'],
    'shrimp': ['shrimp', 'prawn', 'gambas'],
    'prawn': ['shrimp', 'prawn', 'gambas'],
    'تونة': ['tuna'],
    'tuna': ['tuna'],
    'كفتة': ['kefta', 'meatball', 'kofta'],
    'kefta': ['kefta', 'meatball', 'kofta'],
    'meatball': ['kefta', 'meatball', 'kofta'],
    'سمك': ['fish', 'cod', 'salmon', 'hake'],
    'fish': ['fish', 'cod', 'salmon', 'hake'],
  };

  static const Map<String, String> _keywordToMuscleGroup = {
    'صدر': 'Chest',
    'بنش': 'Chest',
    'chest': 'Chest',
    'ظهر': 'Back',
    'لاتس': 'Back',
    'back': 'Back',
    'باي': 'Biceps',
    'بايسبس': 'Biceps',
    'biceps': 'Biceps',
    'تراي': 'Triceps',
    'ترايسبس': 'Triceps',
    'triceps': 'Triceps',
    'كتف': 'Shoulders',
    'أكتاف': 'Shoulders',
    'اكتاف': 'Shoulders',
    'shoulders': 'Shoulders',
    'رجل': 'Quadriceps',
    'أرجل': 'Quadriceps',
    'افخاذ': 'Quadriceps',
    'quads': 'Quadriceps',
    'quadriceps': 'Quadriceps',
    'بطن': 'Abdominals',
    'abs': 'Abdominals',
    'abdominals': 'Abdominals',
    'ترابيس': 'Trapezius',
    'trapezius': 'Trapezius',
    'سواعد': 'Forearms',
    'forearms': 'Forearms',
    'سمانة': 'Calves',
    'calves': 'Calves',
  };

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
    final promptResult = await _buildSystemPrompt(
      profile,
      languageCode,
      messageContent,
    );
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
    String? userMessage,
  ) async {
    final mealBuffer = StringBuffer();
    final muscleBuffer = StringBuffer();
    final catalogMealsMap = <String, String>{};
    final catalogMusclesMap = <String, MuscleEntity>{};

    await _populateMealCatalog(userMessage, mealBuffer, catalogMealsMap);
    await _populateMuscleCatalog(userMessage, muscleBuffer, catalogMusclesMap);

    final promptText = _composePromptText(
      profile: profile,
      languageCode: languageCode,
      mealCatalog: mealBuffer.toString(),
      muscleCatalog: muscleBuffer.toString(),
    );

    return _PromptResult(promptText, catalogMealsMap, catalogMusclesMap);
  }

  Future<void> _populateMealCatalog(
    String? userMessage,
    StringBuffer buffer,
    Map<String, String> catalogMap,
  ) async {
    try {
      final recRes = await _foodRepository.getRecommendationFood();
      if (recRes is! SuccessBaseResponse<RecommendationFoodEntity>) return;
      final categories = recRes.data.categories
          .map((c) => c.strCategory)
          .where((name) => name.isNotEmpty && name != 'Pork')
          .toList();
      final requestedCat = _detectRequestedCategory(userMessage);
      final targetCategories = _prepareTargetCategories(categories, requestedCat);
      final responses = await Future.wait(
        targetCategories.map((c) => _foodRepository.getMealsByCategory(c)),
      );
      _processMealResponses(
        targetCategories,
        responses,
        requestedCat,
        _extractSearchTerms(userMessage),
        buffer,
        catalogMap,
      );
    } catch (_) {}
  }

  List<String> _prepareTargetCategories(List<String> categories, String? requested) {
    final list = List<String>.from(categories);
    if (requested != null && list.contains(requested)) {
      list.remove(requested);
      list.insert(0, requested);
    }
    return list.take(8).toList();
  }

  void _processMealResponses(
    List<String> categories,
    List<BaseResponse<MealsEntity>> responses,
    String? requestedCat,
    List<String> searchTerms,
    StringBuffer buffer,
    Map<String, String> catalogMap,
  ) {
    for (var i = 0; i < responses.length; i++) {
      final res = responses[i];
      if (res is! SuccessBaseResponse<MealsEntity>) continue;
      final catName = categories[i];
      final meals = res.data.meals
          .where((m) => m.id.isNotEmpty && m.name.isNotEmpty)
          .toList();
      _sortMealsByTerms(meals, searchTerms);
      final limit = (catName == requestedCat) ? 10 : 4;
      _writeMealsToBuffer(catName, meals.take(limit), buffer, catalogMap);
    }
  }

  void _sortMealsByTerms(List<MealEntity> meals, List<String> searchTerms) {
    if (searchTerms.isEmpty) return;
    meals.sort((a, b) {
      final aMatch = searchTerms.any((t) => a.name.toLowerCase().contains(t));
      final bMatch = searchTerms.any((t) => b.name.toLowerCase().contains(t));
      if (aMatch && !bMatch) return -1;
      if (!aMatch && bMatch) return 1;
      return 0;
    });
  }

  void _writeMealsToBuffer(
    String catName,
    Iterable<MealEntity> meals,
    StringBuffer buffer,
    Map<String, String> catalogMap,
  ) {
    for (final m in meals) {
      buffer.writeln('- Category "$catName" -> Meal ID "${m.id}": ${m.name}');
      catalogMap[m.id] = m.name;
    }
  }

  Future<void> _populateMuscleCatalog(
    String? userMessage,
    StringBuffer buffer,
    Map<String, MuscleEntity> catalogMap,
  ) async {
    try {
      final groupsRes = await _fitnessRepository.getMuscleGroups();
      if (groupsRes is! SuccessBaseResponse<List<MuscleGroupEntity>>) return;
      final requestedGroup = _detectRequestedMuscleGroup(userMessage);
      final groups = _prepareTargetMuscleGroups(groupsRes.data, requestedGroup);
      final responses = await Future.wait(
        groups.map((g) => _fitnessRepository.getMusclesByGroupId(g.id)),
      );
      for (var i = 0; i < responses.length; i++) {
        final res = responses[i];
        if (res is! SuccessBaseResponse<List<MuscleEntity>>) continue;
        _writeMusclesToBuffer(groups[i].name, res.data, buffer, catalogMap);
      }
    } catch (_) {}
  }

  List<MuscleGroupEntity> _prepareTargetMuscleGroups(
    List<MuscleGroupEntity> groups,
    String? requested,
  ) {
    final list = List<MuscleGroupEntity>.from(groups);
    if (requested != null) {
      final index = list.indexWhere(
        (g) => g.name.toLowerCase() == requested.toLowerCase(),
      );
      if (index > 0) {
        final matched = list.removeAt(index);
        list.insert(0, matched);
      }
    }
    return list.take(10).toList();
  }

  void _writeMusclesToBuffer(
    String groupName,
    List<MuscleEntity> muscles,
    StringBuffer buffer,
    Map<String, MuscleEntity> catalogMap,
  ) {
    for (final m in muscles) {
      if (m.id.isEmpty || m.name.isEmpty) continue;
      final img = m.image.isNotEmpty ? ' (Image: ${m.image})' : '';
      buffer.writeln('- Muscle Group "$groupName" -> Muscle ID "${m.id}": ${m.name}$img');
      catalogMap[m.id] = m;
    }
  }

  String _buildUserProfileSection(ProfileEntity? profile) {
    if (profile == null) return '';
    final details = [
      if (profile.firstName.isNotEmpty) 'Name: ${profile.firstName}',
      if (profile.gender.isNotEmpty) 'Gender: ${profile.gender}',
      if (profile.age > 0) 'Age: ${profile.age}',
      if (profile.weight > 0) 'Weight: ${profile.weight}kg',
      if (profile.height > 0) 'Height: ${profile.height}cm',
      if (profile.goal.isNotEmpty) 'Goal: ${profile.goal}',
    ].join(', ');
    return details.isNotEmpty ? 'User Profile Data: $details.' : '';
  }

  String _composePromptText({
    required ProfileEntity? profile,
    required String languageCode,
    required String mealCatalog,
    required String muscleCatalog,
  }) {
    final profileDetails = _buildUserProfileSection(profile);
    final langInst = languageCode == 'ar'
        ? 'Respond strictly in natural ARABIC (باللغة العربية).'
        : 'Respond strictly in natural ENGLISH.';

    return 'You are Smart Coach, an expert AI fitness & nutrition coach in our Fitness App. '
        '$profileDetails '
        '$langInst '
        'FORBIDDEN: NEVER output external website URLs or http/https links. '
        'CRITICAL EXERCISE RULE: exerciseId MUST BE A SINGLE 24-character hexadecimal ID. NEVER JOIN MULTIPLE IDs. '
        'STRICT CATEGORY MATCHING: '
        '1. Select ONLY a meal matching the user requested food type (e.g. seafood, beef, chicken, pasta, vegetarian). Never recommend chicken or lamb for seafood, or chicken/fish for beef. '
        '2. NEVER hallucinate ingredients. Dish names define the protein type. '
        '3. Pick actual dishes matching requested terms from the catalog. '
        'GUIDELINES: '
        '1. For general chat, answer naturally in plain text ONLY. DO NOT append JSON. '
        '2. IF user asks for meal/recipe recommendation, select a matching meal from catalog below, explain naturally, and append JSON action: '
        '{"action": {"type": "navigateFoodDetails", "title": "<Meal Name>", "params": {"mealId": "<Meal ID>"}}} '
        '3. IF user asks for exercise suggestions/workout, select a SINGLE matching muscle from catalog below, explain naturally, and append JSON action: '
        '{"action": {"type": "navigateExercise", "title": "تمرين <Muscle Name>", "params": {"exerciseId": "<SINGLE Muscle ID>", "muscleName": "<Muscle Name>", "image": "<Muscle Image URL>"}}} '
        'LIVE MEALS CATALOG: $mealCatalog '
        'LIVE MUSCLES CATALOG: $muscleCatalog';
  }

  String? _detectRequestedCategory(String? userMessage) {
    if (userMessage == null || userMessage.isEmpty) return null;
    final msg = userMessage.toLowerCase();
    for (final entry in _keywordToCategory.entries) {
      if (msg.contains(entry.key)) return entry.value;
    }
    return null;
  }

  String? _detectRequestedMuscleGroup(String? userMessage) {
    if (userMessage == null || userMessage.isEmpty) return null;
    final msg = userMessage.toLowerCase();
    for (final entry in _keywordToMuscleGroup.entries) {
      if (msg.contains(entry.key)) return entry.value;
    }
    return null;
  }

  List<String> _extractSearchTerms(String? userMessage) {
    if (userMessage == null || userMessage.isEmpty) return const [];
    final msg = userMessage.toLowerCase();
    final terms = <String>{};
    for (final entry in _keywordToTerms.entries) {
      if (msg.contains(entry.key)) terms.addAll(entry.value);
    }
    return terms.toList();
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

    final base64Images = _encodeImage(imagePath);
    list.add(
      OllamaChatMessagePayload(
        role: 'user',
        content: currentContent,
        images: base64Images,
      ),
    );
    return list;
  }

  List<String>? _encodeImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    try {
      final bytes = File(imagePath).readAsBytesSync();
      return [base64Encode(bytes)];
    } catch (_) {
      return null;
    }
  }

  BaseResponse<ChatMessageEntity> _handleRemoteResponse(
    BaseResponse<dynamic> response,
    Map<String, String> catalogMeals,
    Map<String, MuscleEntity> catalogMuscles,
  ) {
    if (response is ErrorBaseResponse) {
      return ErrorBaseResponse(errorMessage: response.errorMessage);
    }
    if (response is! SuccessBaseResponse) {
      return ErrorBaseResponse(errorMessage: 'Unknown error occurred');
    }
    final resModel = response.data;
    final content = _cleanContent(resModel.contentMessage as String);
    final action = _resolveAction(
      initialAction: resModel.actionModel?.toEntity(),
      content: content,
      catalogMeals: catalogMeals,
      catalogMuscles: catalogMuscles,
    );

    final entity = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
      action: action,
    );
    return SuccessBaseResponse(data: entity);
  }

  String _cleanContent(String content) {
    return content
        .replaceAll(_markdownUrlRegex, '')
        .replaceAll(_rawUrlRegex, '')
        .trim();
  }

  ChatActionEntity? _resolveAction({
    required ChatActionEntity? initialAction,
    required String content,
    required Map<String, String> catalogMeals,
    required Map<String, MuscleEntity> catalogMuscles,
  }) {
    var action = _validateMealAction(initialAction, catalogMeals);
    action ??= _fallbackMealAction(content, catalogMeals);
    action ??= _fallbackExerciseAction(content, catalogMuscles);
    return _sanitizeExerciseAction(action);
  }

  ChatActionEntity? _validateMealAction(
    ChatActionEntity? action,
    Map<String, String> catalogMeals,
  ) {
    if (action == null || action.type != SmartCoachActionType.navigateFoodDetails) {
      return action;
    }
    final title = action.title.toLowerCase();
    for (final entry in catalogMeals.entries) {
      if (entry.value.toLowerCase() == title || title.contains(entry.value.toLowerCase())) {
        return ChatActionEntity(
          type: action.type,
          title: entry.value,
          params: ChatActionParamsEntity(mealId: entry.key),
        );
      }
    }
    return action;
  }

  ChatActionEntity? _fallbackMealAction(
    String content,
    Map<String, String> catalogMeals,
  ) {
    final lower = content.toLowerCase();
    for (final entry in catalogMeals.entries) {
      if (entry.value.length >= 3 && lower.contains(entry.value.toLowerCase())) {
        return ChatActionEntity(
          type: SmartCoachActionType.navigateFoodDetails,
          title: entry.value,
          params: ChatActionParamsEntity(mealId: entry.key),
        );
      }
    }
    return null;
  }

  ChatActionEntity? _fallbackExerciseAction(
    String content,
    Map<String, MuscleEntity> catalogMuscles,
  ) {
    final lower = content.toLowerCase();
    for (final entry in catalogMuscles.entries) {
      final muscle = entry.value;
      if (muscle.name.length >= 3 && lower.contains(muscle.name.toLowerCase())) {
        return ChatActionEntity(
          type: SmartCoachActionType.navigateExercise,
          title: 'تمرين ${muscle.name}',
          params: ChatActionParamsEntity(
            exerciseId: muscle.id,
            muscleName: muscle.name,
            image: muscle.image,
          ),
        );
      }
    }
    return null;
  }

  ChatActionEntity? _sanitizeExerciseAction(ChatActionEntity? action) {
    if (action == null || action.type != SmartCoachActionType.navigateExercise) {
      return action;
    }
    final rawId = action.params.exerciseId ?? '';
    final match = _objectIdRegex.firstMatch(rawId);
    if (match == null) return action;
    return ChatActionEntity(
      type: action.type,
      title: action.title,
      params: ChatActionParamsEntity(
        exerciseId: match.group(0)!,
        muscleName: action.params.muscleName,
        image: action.params.image,
      ),
    );
  }
}
