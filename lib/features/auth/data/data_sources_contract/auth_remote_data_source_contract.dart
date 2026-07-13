import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:fitness_app/features/auth/data/models/auth_response_model.dart';

abstract interface class AuthRemoteDataSourceContract {
  Future<BaseResponse<AuthResponseModel>> forgetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  });

  Future<BaseResponse<AuthResponseModel>> verifyOtp({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  });

  Future<BaseResponse<AuthResponseModel>> resetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  });
}
