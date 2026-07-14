import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/utils/error/error_handler.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:fitness_app/features/auth/data/models/auth_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources_contract/auth_remote_data_source_contract.dart';
import '../api_client/auth_api_client.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);
  AuthResponseModel _getMockAuthResponse() {
    return AuthResponseModel();
  }

  @override
  Future<BaseResponse<AuthResponseModel>> forgetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    try {
      // final response = await _authApiClient.forgetPassword(
      //   forgetPasswordRequestModel,
      // );
      // return SuccessBaseResponse<AuthResponseModel>(data: response);
      return SuccessBaseResponse<AuthResponseModel>(
        data: _getMockAuthResponse(),
      );
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<AuthResponseModel>(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<AuthResponseModel>> verifyOtp({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    try {
      // final response = await _authApiClient.verifyOtp(
      //   forgetPasswordRequestModel,
      // );
      // return SuccessBaseResponse<AuthResponseModel>(data: response);
      return SuccessBaseResponse<AuthResponseModel>(
        data: _getMockAuthResponse(),
      );
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<AuthResponseModel>(errorMessage: message);
    }
  }

  @override
  Future<BaseResponse<AuthResponseModel>> resetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    try {
      // final response = await _authApiClient.resetPassword(
      //   forgetPasswordRequestModel,
      // );await Future.delayed(const Duration(seconds: 1));
      // return SuccessBaseResponse<AuthResponseModel>(data: response);
      return SuccessBaseResponse<AuthResponseModel>(
        data: _getMockAuthResponse(),
      );
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<AuthResponseModel>(errorMessage: message);
    }
  }
}
