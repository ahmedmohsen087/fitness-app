import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/utils/error/error_handler.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/data/models/forget_password_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources_contract/auth_remote_data_source_contract.dart';
import '../api_client/auth_api_client.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);
  ForgetPasswordResponseModel _getMockAuthResponse() {
    return ForgetPasswordResponseModel();
  }

  @override
  Future<BaseResponse<ForgetPasswordResponseModel>> forgetPassword({
    required ForgetPasswordEmailRequestModel forgetPasswordEmailRequestModel,
  }) async {
    try {
      // final response = await _authApiClient.forgetPassword(
      //   forgetPasswordRequestModel,
      // );
      // return SuccessBaseResponse<ForgetPasswordResponseModel>(data: response);
      return SuccessBaseResponse<ForgetPasswordResponseModel>(
        data: _getMockAuthResponse(),
      );
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<ForgetPasswordResponseModel>(
        errorMessage: message,
      );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordResponseModel>> verifyOtp({
    required VerifyResetCodeRequestModel verifyResetCodeRequestModel,
  }) async {
    try {
      // final response = await _authApiClient.verifyOtp(
      //   forgetPasswordRequestModel,
      // );
      // return SuccessBaseResponse<ForgetPasswordResponseModel>(data: response);
      return SuccessBaseResponse<ForgetPasswordResponseModel>(
        data: _getMockAuthResponse(),
      );
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<ForgetPasswordResponseModel>(
        errorMessage: message,
      );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordResponseModel>> resetPassword({
    required ResetPasswordRequestModel resetPasswordRequestModel,
  }) async {
    try {
      // final response = await _authApiClient.resetPassword(
      //   forgetPasswordRequestModel,
      // );await Future.delayed(const Duration(seconds: 1));
      // return SuccessBaseResponse<ForgetPasswordResponseModel>(data: response);
      return SuccessBaseResponse<ForgetPasswordResponseModel>(
        data: _getMockAuthResponse(),
      );
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<ForgetPasswordResponseModel>(
        errorMessage: message,
      );
    }
  }
}
