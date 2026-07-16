import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/register_params.dart';
import '../entities/register_response_entity.dart';
import '../repository_contract/auth_repository_contract.dart';

@injectable
class RegisterUseCase {
  final AuthRepositoryContract _authRepository;

  RegisterUseCase(this._authRepository);

  Future<BaseResponse<RegisterResponseEntity>> execute(RegisterParams params) {
    return _authRepository.signUp(params);
  }
}
