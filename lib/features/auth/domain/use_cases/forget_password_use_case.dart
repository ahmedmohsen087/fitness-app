import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthRepositoryContract _authRepositoryContract;

  ForgetPasswordUseCase(this._authRepositoryContract);

  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) {
    return _authRepositoryContract.forgetPassword(
      forgetPasswordRequestModel: forgetPasswordRequestModel,
    );
  }

  Future<BaseResponse<ForgetPasswordEntity>> verifyOtp({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) {
    return _authRepositoryContract.verifyOtp(
      forgetPasswordRequestModel: forgetPasswordRequestModel,
    );
  }

  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required ForgetPasswordRequestModel forgetPasswordRequestModel,
  }) {
    return _authRepositoryContract.resetPassword(
      forgetPasswordRequestModel: forgetPasswordRequestModel,
    );
  }
}
