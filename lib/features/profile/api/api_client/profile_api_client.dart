import 'package:dio/dio.dart';
import 'package:fitness_app/core/values/api_endpoints.dart';
import 'package:fitness_app/core/values/api_parameters.dart';
import 'package:fitness_app/features/profile/data/models/profile_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../data/models/change_password_response_model.dart';
import '../models/profile_message_model.dart';
import '../request_models/change_password_request_model.dart';
import '../request_models/edit_profile_request_model.dart';

part 'profile_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET(ApiEndpoints.getProfile)
  @Extra({ApiParameters.requiresAuth: true})
  Future<ProfileResponseModel> getProfileData();

  @PUT(ApiEndpoints.editProfile)
  @Extra({ApiParameters.requiresAuth: true})
  Future<ProfileResponseModel> editProfile(
    @Body() EditProfileRequestModel body,
  );

  @MultiPart()
  @PUT(ApiEndpoints.uploadProfilePhoto)
  @Extra({ApiParameters.requiresAuth: true})
  Future<ProfileMessageModel> uploadProfilePhoto(
    @Part(name: ApiParameters.photo) MultipartFile photo,
  );

  @PATCH(ApiEndpoints.changePassword)
  @Extra({ApiParameters.requiresAuth: true})
  Future<ChangePasswordResponseModel> changePassword(
    @Body() ChangePasswordRequestModel body,
  );
}
