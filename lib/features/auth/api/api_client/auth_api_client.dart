import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/values/api_endpoints.dart';
import '../../../../core/values/api_parameters.dart';
import '../models/register_response_model.dart';
import '../request_models/register_request_model.dart';

import '../../../../core/values/api_parameters.dart';
import '../../data/models/login_response.dart';
import '../request_models/login_request_model.dart';

import '../../../../core/values/api_endpoints.dart';
import '../../../../core/values/api_parameters.dart';
import '../models/register_response_model.dart';
import '../request_models/register_request_model.dart';

part 'auth_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(ApiEndpoints.signUp)
  @Extra({ApiParameters.requiresAuth: false})
  Future<RegisterResponseModel> signUp(@Body() RegisterRequestModel body);
  @POST('signin')
  @Extra({ApiParameters.requiresAuth: false})
  Future<LoginResponse> login(
      @Body() LoginRequestModel  body,
      );



}
