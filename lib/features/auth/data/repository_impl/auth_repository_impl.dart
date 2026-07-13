import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:fitness_app/features/auth/data/models/auth_response_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/mappers/auth_response_model_mapper.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/auth/auth_manager.dart';
import '../../domain/repository_contract/auth_repository_contract.dart';
import '../data_sources_contract/auth_remote_data_source_contract.dart';

@Injectable(as: AuthRepositoryContract)
class AuthRepositoryImpl implements AuthRepositoryContract {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthManager _authManager;
  AuthRepositoryImpl(this._remoteDataSource, this._authManager);

  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    final response = await _remoteDataSource.forgetPassword(
      forgetPasswordRequestModel: forgetPasswordRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<AuthResponseModel>(data: final data):
        return SuccessBaseResponse<ForgetPasswordEntity>(
          data: data.toForgetPasswordEntity(
            step: ForgetPasswordRecoveryStep.forget,
          ),
        );
      case ErrorBaseResponse<AuthResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ForgetPasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> verifyOtp({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    final response = await _remoteDataSource.verifyOtp(
      forgetPasswordRequestModel: forgetPasswordRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<AuthResponseModel>(data: final data):
        return SuccessBaseResponse<ForgetPasswordEntity>(
          data: data.toForgetPasswordEntity(
            step: ForgetPasswordRecoveryStep.verify,
          ),
        );
      case ErrorBaseResponse<AuthResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ForgetPasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) async {
    final response = await _remoteDataSource.resetPassword(
      forgetPasswordRequestModel: forgetPasswordRequestModel,
    );
    switch (response) {
      case SuccessBaseResponse<AuthResponseModel>(data: final data):
        return SuccessBaseResponse<ForgetPasswordEntity>(
          data: data.toForgetPasswordEntity(
            step: ForgetPasswordRecoveryStep.reset,
          ),
        );
      case ErrorBaseResponse<AuthResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ForgetPasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }
}
