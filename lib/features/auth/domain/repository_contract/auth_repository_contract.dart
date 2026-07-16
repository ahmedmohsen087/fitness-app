import '../../../../config/base_response/base_response.dart';
import '../entities/register_params.dart';
import '../entities/register_response_entity.dart';

abstract interface class AuthRepositoryContract {
  Future<BaseResponse<RegisterResponseEntity>> signUp(RegisterParams params);
}
