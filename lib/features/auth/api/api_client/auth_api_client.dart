import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/values/api_parameters.dart';
import '../../data/models/login_response.dart';
import '../request_models/login_request_model.dart';

part 'auth_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST('/login')
  @Extra({ApiParameters.requiresAuth: false})
  Future<LoginResponse> login(
      @Body() LoginRequestModel  body,
      );



}
