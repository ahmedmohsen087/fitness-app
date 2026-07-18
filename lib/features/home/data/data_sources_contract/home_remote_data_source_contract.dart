
import '../../../../config/base_response/base_response.dart';
import '../models/muscles_group/muscles_group_by_id_response.dart';
import '../models/muscles_group/muscles_group_response.dart';
import '../models/recommendation_to_day/recommendation_to_day_response.dart';

abstract interface class HomeRemoteDataSourceContract {
  Future<BaseResponse<RecommendationToDayResponse>> getRecommendationToDay();
  Future<BaseResponse<MusclesGroupResponse>> getMusclesGroup();
  Future<BaseResponse<MusclesGroupByIdResponse>> getMusclesGroupId(String id);
}


