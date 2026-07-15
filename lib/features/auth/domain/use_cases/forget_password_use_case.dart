import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthRepositoryContract _authRepositoryContract;

  ForgetPasswordUseCase(this._authRepositoryContract);

  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordEmailRequestModel forgetPasswordEmailRequestModel,
  }) {
    return _authRepositoryContract.forgetPassword(
      forgetPasswordEmailRequestModel: forgetPasswordEmailRequestModel,
    );
  }

  Future<BaseResponse<ForgetPasswordEntity>> verifyOtp({
    required VerifyResetCodeRequestModel verifyResetCodeRequestModel,
  }) {
    return _authRepositoryContract.verifyOtp(
      verifyResetCodeRequestModel: verifyResetCodeRequestModel,
    );
  }

  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required ResetPasswordRequestModel resetPasswordRequestModel,
  }) {
    return _authRepositoryContract.resetPassword(
      resetPasswordRequestModel: resetPasswordRequestModel,
    );
  }
}
