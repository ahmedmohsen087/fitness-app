
import 'package:fitness_app/features/auth/domain/entities/login_user_entity.dart';

import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/login_request_model.dart';

abstract interface class AuthRepositoryContract {

  Future<BaseResponse<LoginUserEntity>> login({
    required LoginRequestModel loginRequestModel,
  });
}
