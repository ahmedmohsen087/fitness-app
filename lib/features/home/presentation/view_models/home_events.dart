
sealed class HomeEvent {}

class LoadHomeDataEvent extends HomeEvent {}

class RetryHomeDataEvent extends HomeEvent {}

class GetMusclesGroupByIdEvent extends HomeEvent {
  final String id;

  GetMusclesGroupByIdEvent(this.id);
}