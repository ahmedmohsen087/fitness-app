import 'package:fitness_app/features/smart_coach/data/models/chat_action_params_model.dart';
import 'package:fitness_app/features/smart_coach/data/models/ollama_chat_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Chat Models Test', () {
    test('ChatActionParamsModel.fromJson parses mealId key correctly', () {
      final json = {'mealId': '52772', 'exerciseId': '69d982ef85f6bfa972bf224e'};
      final model = ChatActionParamsModel.fromJson(json);
      expect(model.mealId, '52772');
      expect(model.exerciseId, '69d982ef85f6bfa972bf224e');
    });

    test('OllamaChatResponseModel extracts JSON action block embedded in content text', () {
      final json = {
        'message': {
          'role': 'assistant',
          'content': '''وجبة غنية بالبروتين والفوائد والصحة!
{"action": {"type": "navigateFoodDetails", "title": "Teriyaki Chicken Casserole", "params": {"mealId": "52772"}}}''',
        }
      };

      final response = OllamaChatResponseModel.fromJson(json);
      expect(response.contentMessage, contains('وجبة غنية بالبروتين'));
      expect(response.actionModel, isNotNull);
      expect(response.actionModel!.typeString, 'navigateFoodDetails');
      expect(response.actionModel!.params.mealId, '52772');
    });
  });
}
