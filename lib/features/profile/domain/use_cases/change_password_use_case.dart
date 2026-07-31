import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/api/request_models/change_password_request_model.dart';
import 'package:fitness_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepositoryContract _profileRepositoryConract;

  ChangePasswordUseCase(this._profileRepositoryConract);

  Future<BaseResponse<ChangePasswordEntity>> execute({
    required ChangePasswordRequestModel changePasswordRequestModel,
  }) {
    return _profileRepositoryConract.changePassword(
      changePasswordRequestModel: changePasswordRequestModel,
    );
  }
}
