import 'package:fitness_app/features/smart_coach/domain/entities/chat_message_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/smart_coach_enums.dart';
import 'package:fitness_app/features/smart_coach/presentation/widgets/smart_coach_active_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets('SmartCoachActiveWidget triggers onSendMessage and clears input', (tester) async {
    String? sentText;

    final widget = SmartCoachActiveWidget(
      messages: [
        ChatMessageEntity(
          id: '1',
          content: 'Hello',
          sender: MessageSender.user,
          timestamp: DateTime(2026),
        ),
      ],
      isLoadingAi: false,
      onSendMessage: (text, imagePath) {
        sentText = text;
      },
      onImageAttached: (_) {},
      onClearImage: () {},
    );

    await tester.pumpWidget(buildTestableWidget(widget));

    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    await tester.enterText(textField, 'Recommend a meal');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(sentText, 'Recommend a meal');
  });
}
