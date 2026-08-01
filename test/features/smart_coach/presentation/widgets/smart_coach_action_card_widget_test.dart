import 'package:fitness_app/features/smart_coach/domain/entities/chat_action_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/chat_action_params_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/smart_coach_enums.dart';
import 'package:fitness_app/features/smart_coach/presentation/widgets/smart_coach_action_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders action title and details button', (tester) async {
    const action = ChatActionEntity(
      type: SmartCoachActionType.navigateExercise,
      title: 'تمرين Pectoralis Major',
      params: ChatActionParamsEntity(
        exerciseId: '69d982ef85f6bfa972bf224e, 69d982f085f6bfa972bf225a',
        muscleName: 'Pectoralis Major',
        image: '',
      ),
    );

    await tester.pumpWidget(buildTestableWidget(const SmartCoachActionCardWidget(action: action)));

    expect(find.text('تمرين Pectoralis Major'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
