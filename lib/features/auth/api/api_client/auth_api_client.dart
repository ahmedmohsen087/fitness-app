import 'package:dio/dio.dart';
import 'package:fitness_app/core/values/api_endpoints.dart';
import 'package:fitness_app/core/values/api_parameters.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/data/models/forget_password_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @Extra({ApiParameters.requiresAuth: false})
  @POST(ApiEndpoints.forgetPassword)
  Future<ForgetPasswordResponseModel> forgetPassword(
    @Body() ForgetPasswordEmailRequestModel body,
  );

  @Extra({ApiParameters.requiresAuth: false})
  @POST(ApiEndpoints.verifyOtp)
  Future<ForgetPasswordResponseModel> verifyOtp(
    @Body() VerifyResetCodeRequestModel body,
  );

  @Extra({ApiParameters.requiresAuth: false})
  @PUT(ApiEndpoints.resetPassword)
  Future<ForgetPasswordResponseModel> resetPassword(
    @Body() ResetPasswordRequestModel body,
  );
}
