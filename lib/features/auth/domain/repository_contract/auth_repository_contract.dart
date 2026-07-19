import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/login_request_model.dart';
import '../entities/login_user_entity.dart';
import '../entities/register_params.dart';
import '../entities/register_response_entity.dart';

abstract interface class AuthRepositoryContract {
  Future<BaseResponse<RegisterResponseEntity>> signUp(RegisterParams params);

  Future<BaseResponse<LoginUserEntity>> login({
    required LoginRequestModel loginRequestModel,
  });
}
