import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';

abstract interface class AuthRepositoryContract {
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  });

  Future<BaseResponse<ForgetPasswordEntity>> verifyOtp({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  });

  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  });
}
