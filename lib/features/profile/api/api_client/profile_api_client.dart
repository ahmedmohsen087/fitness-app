import 'package:dio/dio.dart';
import 'package:fitness_app/core/values/api_endpoints.dart';
import 'package:fitness_app/core/values/api_parameters.dart';
import 'package:fitness_app/features/profile/data/models/profile_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'profile_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET(ApiEndpoints.getProfile)
  @Extra({ApiParameters.requiresAuth: true})
  Future<ProfileResponseModel> getProfileData();
}
