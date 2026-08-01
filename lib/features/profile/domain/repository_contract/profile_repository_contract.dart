import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';

import '../entities/edit_profile_params.dart';
import '../entities/profile_message_entity.dart';
import '../entities/upload_profile_photo_params.dart';

abstract interface class ProfileRepositoryContract {
  Future<BaseResponse<ProfileResponseEntity>> getProfileData();

  Future<BaseResponse<ProfileResponseEntity>> editProfile(
    EditProfileParams params,
  );

  Future<BaseResponse<ProfileMessageEntity>> uploadProfilePhoto(
    UploadProfilePhotoParams params,
  );
}
