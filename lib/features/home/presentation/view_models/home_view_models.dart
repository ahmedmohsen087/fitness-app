import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../config/base_state/base_state.dart';
import '../../../food/domain/use_cases/get_recommendation_food_use_case.dart';
import '../../domain/use_cases/get_muscles_group_by_id_use_case.dart';
import '../../domain/use_cases/get_muscles_group_use_case.dart';
import '../../domain/use_cases/get_recommendation_to_day_use_case.dart';
import 'home_events.dart';
import 'home_states.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final GetRecommendationToDayUseCase _getRecommendationToDayUseCase;
  final GetMusclesGroupUseCase _getMusclesGroupUseCase;
  final GetMusclesGroupByIdUseCase _getMusclesGroupByIdUseCase;
  final GetRecommendationFoodUseCase _getRecommendationFoodUseCase;

  HomeViewModel(
    this._getRecommendationToDayUseCase,
    this._getMusclesGroupUseCase,
    this._getMusclesGroupByIdUseCase,
    this._getRecommendationFoodUseCase,
  ) : super(const HomeState());

  String? selectedMuscleGroupId;

  void doEvent(HomeEvent event) {
    switch (event) {
      case LoadHomeDataEvent():
        _loadHomeData();
      case GetMusclesGroupByIdEvent():
        onMuscleGroupSelected(event.id);
      case RetryHomeDataEvent():
        _retryLoadHomeData();
    }
  }

  void _loadHomeData() {
    _getRecommendationToDay();
    _getMusclesGroup();
    _getRecommendationFood();
  }

  void _retryLoadHomeData() {
    if (state.recommendationToDayState.msg != null) {
      _getRecommendationToDay();
    }

    if (state.musclesGroupState.msg != null) {
      _getMusclesGroup();
    }

    if (state.musclesGroupByIdState.msg != null &&
        selectedMuscleGroupId != null) {
      _getMusclesGroupById(selectedMuscleGroupId!);
    }
    if (state.recommendationFoodState.msg != null) {
      _getRecommendationFood();
    }
  }

  Future<void> _getRecommendationToDay() async {
    emit(state.copyWith(recommendationToDayState: BaseState.loading()));

    final response = await _getRecommendationToDayUseCase.execute();
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            recommendationToDayState: BaseState.success(response.data),
          ),
        );

      case ErrorBaseResponse():
        emit(
          state.copyWith(
            recommendationToDayState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _getMusclesGroup() async {
    emit(state.copyWith(musclesGroupState: BaseState.loading()));

    final response = await _getMusclesGroupUseCase.execute();
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse():
        final data = response.data;

        emit(state.copyWith(musclesGroupState: BaseState.success(data)));

        if (data.musclesGroup.isNotEmpty) {
          selectedMuscleGroupId = data.musclesGroup.first.id;
          await _getMusclesGroupById(selectedMuscleGroupId!);
        }

      case ErrorBaseResponse():
        emit(
          state.copyWith(
            musclesGroupState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> onMuscleGroupSelected(String id) async {
    selectedMuscleGroupId = id;
    await _getMusclesGroupById(id);
  }

  Future<void> _getMusclesGroupById(String id) async {
    emit(state.copyWith(musclesGroupByIdState: BaseState.loading()));

    final response = await _getMusclesGroupByIdUseCase.execute(id);
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            musclesGroupByIdState: BaseState.success(response.data),
          ),
        );

      case ErrorBaseResponse():
        emit(
          state.copyWith(
            musclesGroupByIdState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _getRecommendationFood() async {
    emit(state.copyWith(recommendationFoodState: BaseState.loading()));
    final response = await _getRecommendationFoodUseCase.execute();
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            recommendationFoodState: BaseState.success(response.data),
          ),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            recommendationFoodState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }
}
