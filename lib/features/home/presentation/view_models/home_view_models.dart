import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../domain/entities/muscles_group/muscles_group_by_id_entity.dart';
import '../../domain/entities/muscles_group/muscles_group_entity.dart';
import '../../domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';
import '../../domain/use_cases/home_use_case.dart';
import 'home_states.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final HomeUseCase homeUseCase;

  HomeViewModel(this.homeUseCase) : super(HomeInitialState());

  RecommendationToDayEntity? recommendationToDay;
  MusclesGroupEntity? musclesGroup;
  MusclesGroupByIdEntity? musclesGroupById;

  String? selectedMuscleGroupId;

  Future<void> getRecommendationToDay() async {
    emit(HomeLoadingState());

    final response = await homeUseCase.getRecommendationToDay();

    switch (response) {
      case SuccessBaseResponse(data: final data):
        recommendationToDay = data;
        emit( HomeSuccessState());

      case ErrorBaseResponse(errorMessage: final errorMessage):
        emit(HomeErrorState(errorMessage));
    }
  }

  Future<void> getMusclesGroup() async {
    emit( HomeLoadingState());

    final response = await homeUseCase.getMusclesGroup();

    switch (response) {
      case SuccessBaseResponse(data: final data):
        musclesGroup = data;

        // أول عنصر يكون Selected تلقائياً
        if (data.musclesGroup.isNotEmpty) {
          selectedMuscleGroupId = data.musclesGroup.first.id;
        }

        emit( HomeSuccessState());

      case ErrorBaseResponse(errorMessage: final errorMessage):
        emit(HomeErrorState(errorMessage));
    }
  }

  Future<void> getMusclesGroupById(String id) async {
    selectedMuscleGroupId = id;

    emit( HomeLoadingState());

    final response = await homeUseCase.getMusclesGroupId(id);

    switch (response) {
      case SuccessBaseResponse(data: final data):
        musclesGroupById = data;
        emit(HomeSuccessState());

      case ErrorBaseResponse(errorMessage: final errorMessage):
        emit(HomeErrorState(errorMessage));
    }
  }
}