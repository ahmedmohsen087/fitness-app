import 'package:fitness_app/features/smart_coach/domain/entities/chat_message_entity.dart';
import 'package:fitness_app/features/smart_coach/domain/entities/smart_coach_enums.dart';
import 'package:fitness_app/features/smart_coach/presentation/widgets/smart_coach_bubble_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestableWidget(Widget child, {TextDirection direction = TextDirection.ltr}) {
    return MaterialApp(
      home: Directionality(
        textDirection: direction,
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('renders user message bubble correctly', (tester) async {
    final message = ChatMessageEntity(
      id: '1',
      content: 'User message',
      sender: MessageSender.user,
      timestamp: DateTime(2026),
    );

    await tester.pumpWidget(buildTestableWidget(SmartCoachBubbleWidget(message: message)));

    expect(find.text('User message'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('renders bot message bubble correctly in RTL direction', (tester) async {
    final message = ChatMessageEntity(
      id: '2',
      content: 'مرحبا بك',
      sender: MessageSender.ai,
      timestamp: DateTime(2026),
    );

    await tester.pumpWidget(
      buildTestableWidget(
        SmartCoachBubbleWidget(message: message),
        direction: TextDirection.rtl,
      ),
    );

    expect(find.text('مرحبا بك'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });
}
