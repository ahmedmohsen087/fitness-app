import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:fitness_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
  final AuthRepositoryContract _authRepository;

  LogoutUseCase(this._authRepository);

  Future<BaseResponse<RegisterResponseEntity>> execute() {
    return _authRepository.logout();
  }
}
