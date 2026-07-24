import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../../core/values/api_endpoints.dart';
import '../../../../core/values/api_parameters.dart';

import '../../data/models/muscles_group/muscles_group_by_id_response.dart';
import '../../data/models/muscles_group/muscles_group_response.dart';
import '../../data/models/recommendation_to_day/recommendation_to_day_response.dart';

part 'home_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(Dio dio) = _HomeApiClient;

  @GET(ApiEndpoints.muscles)
  @Extra({ApiParameters.requiresAuth: true})
  Future<RecommendationToDayResponse> getRecommendationToDay();

  @GET(ApiEndpoints.musclesGroup)
  @Extra({ApiParameters.requiresAuth: true})
  Future<MusclesGroupResponse> getMusclesGroup();

  @GET(ApiEndpoints.musclesGroupId)
  @Extra({ApiParameters.requiresAuth: true})
  Future<MusclesGroupByIdResponse> getMusclesGroupById(@Path("id") String id);
}
