import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/data/models/forget_password_response_model.dart';
import 'package:fitness_app/features/auth/data/models/login_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../core/utils/error/error_handler.dart';
import '../../api/models/register_response_model.dart';
import '../../api/request_models/register_request_model.dart';
import '../../data/data_sources_contract/auth_remote_data_source_contract.dart';
import '../api_client/auth_api_client.dart';
import '../request_models/login_request_model.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  ForgetPasswordResponseModel _getMockAuthResponse() {
    return ForgetPasswordResponseModel();
  }

  @override
  Future<BaseResponse<RegisterResponseModel>> signUp(
    RegisterRequestModel body,
  ) async {
    try {
      final response = await _authApiClient.signUp(body);
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(e));
    }
  }

  @override
  Future<BaseResponse<LoginResponse>> login({
    required LoginRequestModel loginRequestModel,
  }) async {
    try {
      final response = await _authApiClient.login(loginRequestModel);
      return SuccessBaseResponse<LoginResponse>(data: response);
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<LoginResponse>(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<RegisterResponseModel>> logout() async {
    try {
      final response = await _authApiClient.logout();
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(e));
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordResponseModel>> forgetPassword({
    required ForgetPasswordEmailRequestModel forgetPasswordEmailRequestModel,
  }) async {
    try {
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
