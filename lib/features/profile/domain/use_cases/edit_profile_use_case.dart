import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/edit_profile_params.dart';
import '../entities/profile_response_entity.dart';
import '../repository_contract/profile_repository_contract.dart';

@injectable
class EditProfileUseCase {
  final ProfileRepositoryContract _repository;

  EditProfileUseCase(this._repository);

  Future<BaseResponse<ProfileResponseEntity>> execute(
    EditProfileParams params,
  ) {
    return _repository.editProfile(params);
  }
}
