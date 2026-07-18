
import '../../domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';

abstract class HomeState  {
  const HomeState();
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeSuccessState extends HomeState {
  final RecommendationToDayEntity recommendation;

  const HomeSuccessState(this.recommendation);


}

class HomeErrorState extends HomeState {
  final String message;

  const HomeErrorState(this.message);


}