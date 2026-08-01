import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/profile_message_entity.dart';
import '../entities/upload_profile_photo_params.dart';
import '../repository_contract/profile_repository_contract.dart';

@injectable
class UploadProfilePhotoUseCase {
  final ProfileRepositoryContract _repository;

  UploadProfilePhotoUseCase(this._repository);

  Future<BaseResponse<ProfileMessageEntity>> execute(
    UploadProfilePhotoParams params,
  ) {
    return _repository.uploadProfilePhoto(params);
  }
}
