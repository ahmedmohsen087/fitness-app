import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/home/api/api_client/home_api_client.dart';
import 'package:fitness_app/features/home/data/data_sources_contract/home_remote_data_source_contract.dart';
import 'package:fitness_app/features/home/data/models/recommendation_to_day/recommendation_to_day_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/error/error_handler.dart';
import '../../data/models/muscles_group/muscles_group_by_id_response.dart';
import '../../data/models/muscles_group/muscles_group_response.dart';
@Injectable(as: HomeRemoteDataSourceContract)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSourceContract{
  final HomeApiClient homeApiClient ;
  HomeRemoteDataSourceImpl(
    this.homeApiClient
);

  @override
  Future<BaseResponse<RecommendationToDayResponse>> getRecommendationToDay() async {
    try{
      final response = await homeApiClient.getRecommendationToDay();
      return SuccessBaseResponse<RecommendationToDayResponse>(data: response);
    }catch(e){
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<RecommendationToDayResponse>(errorMessage: message) ;
    }
  }

  @override
  Future<BaseResponse<MusclesGroupResponse>> getMusclesGroup() async {
    try{
      final response = await homeApiClient.getMusclesGroup();
      return SuccessBaseResponse<MusclesGroupResponse>(data: response);
      }catch(e){
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<MusclesGroupResponse>(errorMessage: message) ;
    }
  }
  @override
  Future<BaseResponse<MusclesGroupByIdResponse>> getMusclesGroupId(String id) async {
    try{
      final response = await homeApiClient.getMusclesGroupById(id);
      return SuccessBaseResponse<MusclesGroupByIdResponse>(data: response);
      }catch(e){
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<MusclesGroupByIdResponse>(errorMessage: message) ;
    }
  }





}