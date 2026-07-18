import '../../domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {

}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState(this.message);
}