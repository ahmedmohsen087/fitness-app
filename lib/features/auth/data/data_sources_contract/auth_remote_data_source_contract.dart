import 'package:fitness_app/features/auth/data/models/login_response.dart';

import '../../../../config/base_response/base_response.dart';
import '../../api/models/register_response_model.dart';
import '../../api/request_models/login_request_model.dart';
import '../../api/request_models/register_request_model.dart';

abstract interface class AuthRemoteDataSourceContract {
  Future<BaseResponse<RegisterResponseModel>> signUp(RegisterRequestModel body);
  Future<BaseResponse<LoginResponse>> login({
    required LoginRequestModel loginRequestModel,
  });
}
