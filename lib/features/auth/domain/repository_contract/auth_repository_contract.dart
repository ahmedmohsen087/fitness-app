import '../../../../config/base_response/base_response.dart';
import '../entities/register_params.dart';
import '../entities/register_response_entity.dart';

import 'package:fitness_app/features/auth/domain/entities/login_user_entity.dart';

import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/login_request_model.dart';

abstract interface class AuthRepositoryContract {
  Future<BaseResponse<RegisterResponseEntity>> signUp(RegisterParams params);

  Future<BaseResponse<LoginUserEntity>> login({
    required LoginRequestModel loginRequestModel,
  });
}
