import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/data/models/forget_password_response_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/entities/login_user_entity.dart';
import 'package:fitness_app/features/auth/domain/mappers/auth_response_model_mapper.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/auth/auth_manager.dart';
import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/login_request_model.dart';
import '../../api/request_models/register_request_model.dart';
import '../../domain/entities/register_params.dart';
import '../../domain/entities/register_response_entity.dart';
import '../../domain/repository_contract/auth_repository_contract.dart';
import '../data_sources_contract/auth_remote_data_source_contract.dart';
import '../models/login_response.dart';

@Injectable(as: AuthRepositoryContract)
class AuthRepositoryImpl implements AuthRepositoryContract {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthManager _authManager;

  AuthRepositoryImpl(this._remoteDataSource, this._authManager);

  @override
  Future<BaseResponse<LoginUserEntity>> login({
    required LoginRequestModel loginRequestModel,
  }) async {
    final response = await _remoteDataSource.login(
      loginRequestModel: loginRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<LoginResponse>(data: final data):
        final entity = data.toEntity();
        if (data.token != null) {
          await _authManager.setAuthData(token: data.token!);
        }
        return SuccessBaseResponse<LoginUserEntity>(data: entity);
      case ErrorBaseResponse<LoginResponse>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<LoginUserEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<RegisterResponseEntity>> signUp(
    RegisterParams params,
  ) async {
    final body = RegisterRequestModel.fromParams(params);
    final response = await _remoteDataSource.signUp(body);

    switch (response) {
      case SuccessBaseResponse<dynamic>():
        final model = (response as SuccessBaseResponse).data;
        final token = model.token;

        if (token != null && token.isNotEmpty) {
          await _authManager.setAuthData(token: token);
        }

        return SuccessBaseResponse(data: model.toEntity());

      case ErrorBaseResponse<dynamic>():
        return ErrorBaseResponse(
          errorMessage: (response as ErrorBaseResponse).errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordEmailRequestModel forgetPasswordEmailRequestModel,
  }) async {
    final response = await _remoteDataSource.forgetPassword(
      forgetPasswordEmailRequestModel: forgetPasswordEmailRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<ForgetPasswordResponseModel>(data: final data):
        return SuccessBaseResponse<ForgetPasswordEntity>(
          data: data.toForgetPasswordEntity(
            step: ForgetPasswordRecoveryStep.forget,
          ),
        );
      case ErrorBaseResponse<ForgetPasswordResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ForgetPasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> verifyOtp({
    required VerifyResetCodeRequestModel verifyResetCodeRequestModel,
  }) async {
    final response = await _remoteDataSource.verifyOtp(
      verifyResetCodeRequestModel: verifyResetCodeRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<ForgetPasswordResponseModel>(data: final data):
        return SuccessBaseResponse<ForgetPasswordEntity>(
          data: data.toForgetPasswordEntity(
            step: ForgetPasswordRecoveryStep.verify,
          ),
        );
      case ErrorBaseResponse<ForgetPasswordResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ForgetPasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required ResetPasswordRequestModel resetPasswordRequestModel,
  }) async {
    final response = await _remoteDataSource.resetPassword(
      resetPasswordRequestModel: resetPasswordRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<ForgetPasswordResponseModel>(data: final data):
        return SuccessBaseResponse<ForgetPasswordEntity>(
          data: data.toForgetPasswordEntity(
            step: ForgetPasswordRecoveryStep.reset,
          ),
        );
      case ErrorBaseResponse<ForgetPasswordResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ForgetPasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }
}
