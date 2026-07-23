import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/utils/app_routes.dart';
import 'package:fitness_app/features/home/domain/entities/category_food/category_food_entity.dart';
import 'package:fitness_app/features/home/domain/entities/category_food/recommendation_food_entity.dart';
import 'package:fitness_app/features/home/presentation/screens/food_screen.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_events.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_states.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_view_models.dart';
import 'package:fitness_app/features/home/presentation/widgets/recommendation_for_you_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recommendation_for_you_widget_test.mocks.dart';

@GenerateMocks([HomeViewModel])
void main() {
  late MockHomeViewModel homeViewModel;
  late MockHomeViewModel foodViewModel;

  setUp(() {
    homeViewModel = MockHomeViewModel();
    foodViewModel = MockHomeViewModel();
    _stubViewModel(foodViewModel, const HomeState());
    getIt.registerFactory<HomeViewModel>(() => foodViewModel);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('retries an error then opens the selected Food category', (
    tester,
  ) async {
    final states = StreamController<HomeState>.broadcast();
    addTearDown(states.close);
    final errorState = HomeState(
      recommendationFoodState: BaseState.error('offline'),
    );
    when(homeViewModel.state).thenReturn(errorState);
    when(homeViewModel.stream).thenAnswer((_) => states.stream);
    when(homeViewModel.isClosed).thenReturn(false);
    when(homeViewModel.close()).thenAnswer((_) async {});

    await _pumpRecommendation(tester, homeViewModel);

    expect(find.text('offline'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    final retryEvent = verify(
      homeViewModel.doEvent(captureAny),
    ).captured.single;
    expect(retryEvent, isA<RetryHomeDataEvent>());

    states.add(
      HomeState(
        recommendationFoodState: BaseState.success(
          const RecommendationFoodEntity(
            categories: [
              CategoryFoodEntity(
                idCategory: '1',
                strCategory: 'Seafood',
                strCategoryThumb: 'https://example.com/seafood.png',
                strCategoryDescription: '',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Seafood'));
    await tester.pumpAndSettle();

    expect(find.byType(FoodScreen), findsOneWidget);
    final navigationEvent =
        verify(foodViewModel.doEvent(captureAny)).captured.single
            as LoadFoodDataEvent;
    expect(navigationEvent.initialCategory, 'Seafood');
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpRecommendation(
  WidgetTester tester,
  HomeViewModel viewModel,
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
          onGenerateRoute: AppRoutes.onGenerateRoute,
          home: Scaffold(
            body: BlocProvider<HomeViewModel>.value(
              value: viewModel,
              child: const RecommendationForYouWidget(),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void _stubViewModel(MockHomeViewModel viewModel, HomeState state) {
  when(viewModel.state).thenReturn(state);
  when(viewModel.stream).thenAnswer((_) => const Stream.empty());
  when(viewModel.isClosed).thenReturn(false);
  when(viewModel.close()).thenAnswer((_) async {});
}
