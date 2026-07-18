
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/muscles_group/muscles_group_by_id_entity.dart';
import '../../domain/entities/muscles_group/muscles_group_entity.dart';
import '../data_sources_contract/home_remote_data_source_contract.dart';
import '../../domain/entities/recommendation_to_day/recommendation_to_day_entity.dart';
import '../../domain/repository_contract/home_repository_contract.dart';
import '../models/muscles_group/muscles_group_by_id_response.dart';
import '../models/muscles_group/muscles_group_response.dart';
import '../models/recommendation_to_day/recommendation_to_day_response.dart';

@Injectable(as: HomeRepositoryContract)
class HomeRepositoryImpl implements HomeRepositoryContract{
  final HomeRemoteDataSourceContract homeRemoteDataSource;
  HomeRepositoryImpl(this.homeRemoteDataSource);

  @override
  Future<BaseResponse<RecommendationToDayEntity>> getRecommendationToDay() async {

      final response = await homeRemoteDataSource.getRecommendationToDay();
      switch(response){
        case SuccessBaseResponse<RecommendationToDayResponse>(data: final data):
          final entity = data.toEntity();
          return SuccessBaseResponse<RecommendationToDayEntity>(data: entity);
        case ErrorBaseResponse<RecommendationToDayResponse>(errorMessage: final errorMessage):
          return ErrorBaseResponse<RecommendationToDayEntity>(errorMessage: errorMessage);
      }
  }
  @override
  Future<BaseResponse<MusclesGroupEntity>> getMusclesGroup() async {
    final response = await homeRemoteDataSource.getMusclesGroup();
    switch(response){
      case SuccessBaseResponse<MusclesGroupResponse>(data: final data):
        final entity = data.toEntity();
        return SuccessBaseResponse<MusclesGroupEntity>(data: entity);
      case ErrorBaseResponse<MusclesGroupResponse>(errorMessage: final errorMessage):
        return ErrorBaseResponse<MusclesGroupEntity>(errorMessage: errorMessage);
    }
  }
  @override
  Future<BaseResponse<MusclesGroupByIdEntity>> getMusclesGroupId(String id) async {
    final response = await homeRemoteDataSource.getMusclesGroupId(id);
    switch(response){
      case SuccessBaseResponse<MusclesGroupByIdResponse>(data: final data):
        return SuccessBaseResponse(
          data: data.toEntity(),
        );
      case ErrorBaseResponse<MusclesGroupByIdResponse>(errorMessage: final errorMessage):
        return ErrorBaseResponse<MusclesGroupByIdEntity>(errorMessage: errorMessage);

    }
  }

    }






