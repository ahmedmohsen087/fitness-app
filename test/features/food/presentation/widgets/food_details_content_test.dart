import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/features/food/domain/entities/food_details/meal_details_entity.dart';
import 'package:fitness_app/features/food/domain/entities/food_details/meal_ingredient_entity.dart';
import 'package:fitness_app/features/food/presentation/widgets/food_details_content.dart';
import 'package:fitness_app/features/food/presentation/widgets/food_details_ingredients_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('covers content, video state, and collapsed-title animation', (
    tester,
  ) async {
    final meal = ValueNotifier<MealDetailsEntity>(_mealWithVideo);
    addTearDown(meal.dispose);
    await _pumpContent(tester, meal);

    expect(find.text('Baked salmon'), findsNWidgets(2));
    expect(find.text('Seafood'), findsOneWidget);
    expect(find.text('British'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      0,
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1,
    );
    expect(
      tester.widget<AnimatedSlide>(find.byType(AnimatedSlide)).offset,
      Offset.zero,
    );

    meal.value = _meal;
    await tester.pump();
    expect(find.byIcon(Icons.play_arrow_rounded), findsNothing);
    expect(find.text('Ingredient 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders every ingredient with its measure', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FoodDetailsIngredientsCard(meal: _meal),
          ),
        ),
      ),
    );

    expect(find.text('Ingredient 1'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Ingredient 16'), findsOneWidget);
    expect(find.text('16'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpContent(
  WidgetTester tester,
  ValueNotifier<MealDetailsEntity> meal,
) async {
  await tester.pumpWidget(
    EasyLocalization(
      key: UniqueKey(),
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: false,
      child: Builder(
        builder: (context) => MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ValueListenableBuilder<MealDetailsEntity>(
              valueListenable: meal,
              builder: (_, value, _) => FoodDetailsContent(meal: value),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

const _meal = MealDetailsEntity(
  id: '52959',
  name: 'Baked salmon',
  category: 'Seafood',
  area: 'British',
  country: 'United Kingdom',
  instructions: 'Bake until cooked.',
  thumbnail: 'https://example.com/meal.jpg',
  tags: ['Baking'],
  youtubeUrl: '',
  ingredients: _ingredients,
);

const _mealWithVideo = MealDetailsEntity(
  id: '52959',
  name: 'Baked salmon',
  category: 'Seafood',
  area: 'British',
  country: 'United Kingdom',
  instructions: 'Bake until cooked.',
  thumbnail: 'https://example.com/meal.jpg',
  tags: ['Baking'],
  youtubeUrl: 'https://www.youtube.com/watch?v=xvPR2Tfw5k0',
  ingredients: _ingredients,
);

const _ingredients = [
  MealIngredientEntity(name: 'Ingredient 1', measure: '1'),
  MealIngredientEntity(name: 'Ingredient 2', measure: '2'),
  MealIngredientEntity(name: 'Ingredient 3', measure: '3'),
  MealIngredientEntity(name: 'Ingredient 4', measure: '4'),
  MealIngredientEntity(name: 'Ingredient 5', measure: '5'),
  MealIngredientEntity(name: 'Ingredient 6', measure: '6'),
  MealIngredientEntity(name: 'Ingredient 7', measure: '7'),
  MealIngredientEntity(name: 'Ingredient 8', measure: '8'),
  MealIngredientEntity(name: 'Ingredient 9', measure: '9'),
  MealIngredientEntity(name: 'Ingredient 10', measure: '10'),
  MealIngredientEntity(name: 'Ingredient 11', measure: '11'),
  MealIngredientEntity(name: 'Ingredient 12', measure: '12'),
  MealIngredientEntity(name: 'Ingredient 13', measure: '13'),
  MealIngredientEntity(name: 'Ingredient 14', measure: '14'),
  MealIngredientEntity(name: 'Ingredient 15', measure: '15'),
  MealIngredientEntity(name: 'Ingredient 16', measure: '16'),
];
