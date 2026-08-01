import 'dart:convert';
import 'package:fitness_app/core/values/api_parameters.dart';
import 'chat_action_model.dart';
import 'chat_action_params_model.dart';

class OllamaChatResponseModel {
  final String contentMessage;
  final ChatActionModel? actionModel;

  const OllamaChatResponseModel({
    required this.contentMessage,
    this.actionModel,
  });

  factory OllamaChatResponseModel.fromJson(
    Map<String, dynamic> json, {
    Map<String, String> liveCatalogMeals = const {},
  }) {
    final messageData = json[ApiParameters.message] as Map<String, dynamic>?;
    final rawContent = messageData?[ApiParameters.content] as String? ?? '';

    final parsed = _parseRawContent(rawContent);
    if (parsed.actionModel != null || liveCatalogMeals.isEmpty) return parsed;

    final contentLower = parsed.contentMessage.toLowerCase();
    for (final entry in liveCatalogMeals.entries) {
      final mealId = entry.key;
      final mealName = entry.value;
      if (contentLower.contains(mealId.toLowerCase()) ||
          contentLower.contains(mealName.toLowerCase())) {
        return OllamaChatResponseModel(
          contentMessage: parsed.contentMessage,
          actionModel: ChatActionModel(
            typeString: 'navigateFoodDetails',
            title: mealName,
            params: ChatActionParamsModel(mealId: mealId),
          ),
        );
      }
    }

    return parsed;
  }

  static OllamaChatResponseModel _parseRawContent(String rawContent) {
    final trimmed = rawContent.trim();
    
    try {
      final decoded = jsonDecode(trimmed) as Map<String, dynamic>;
      return _buildFromDecodedMap(decoded, trimmed);
    } catch (_) {}

    final jsonRegExp = RegExp(r'\{[\s\S]*"action"\s*:[\s\S]*\}');
    final match = jsonRegExp.firstMatch(trimmed);

    ChatActionModel? extractedAction;
    String cleanText = trimmed;

    if (match != null) {
      final jsonStr = match.group(0)!;
      try {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        final parsed = _buildFromDecodedMap(decoded, cleanText);
        extractedAction = parsed.actionModel;
        cleanText = cleanText.replaceFirst(jsonStr, '');
      } catch (_) {}
    }

    cleanText = cleanText
        .replaceAll(RegExp(r'```(?:json)?', caseSensitive: false), '')
        .replaceAll(RegExp(r'```'), '')
        .replaceAll(RegExp(r'\n\s*\n+'), '\n\n')
        .trim();

    final finalMessage = cleanText.isNotEmpty ? cleanText : rawContent;

    return OllamaChatResponseModel(
      contentMessage: finalMessage,
      actionModel: extractedAction,
    );
  }

  static OllamaChatResponseModel _buildFromDecodedMap(
    Map<String, dynamic> decoded,
    String fallbackRaw,
  ) {
    final message = decoded[ApiParameters.message] as String? ?? fallbackRaw;
    ChatActionModel? action;
    if (decoded['action'] is Map<String, dynamic>) {
      action = ChatActionModel.fromJson(
        decoded['action'] as Map<String, dynamic>,
      );
    }
    return OllamaChatResponseModel(
      contentMessage: message,
      actionModel: action,
    );
  }
}
