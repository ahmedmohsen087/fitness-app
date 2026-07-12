import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/login_request_model.dart';
import '../entities/login_user_entity.dart';
import '../repository_contract/auth_repository_contract.dart';

@injectable
class LoginUseCase {
  final AuthRepositoryContract _loginRepository;

  LoginUseCase(this._loginRepository);

  Future<BaseResponse<LoginUserEntity>> execute({
    required LoginRequestModel loginRequestModel,
  }) {
    return _loginRepository.login(loginRequestModel: loginRequestModel);
  }
}
