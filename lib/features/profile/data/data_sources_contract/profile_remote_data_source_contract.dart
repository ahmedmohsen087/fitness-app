import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/data/models/profile_response_model.dart';

import '../models/change_password_response_model.dart';
import '../../api/models/profile_message_model.dart';
import '../../api/request_models/change_password_request_model.dart';
import '../../api/request_models/edit_profile_request_model.dart';
import '../../api/request_models/upload_profile_photo_request_model.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<BaseResponse<ProfileResponseModel>> getProfileData();

  Future<BaseResponse<ProfileResponseModel>> editProfile(
    EditProfileRequestModel body,
  );

  Future<BaseResponse<ProfileMessageModel>> uploadProfilePhoto(
    UploadProfilePhotoRequestModel body,
  );

  Future<BaseResponse<ChangePasswordResponseModel>> changePassword(
    ChangePasswordRequestModel body,
  );
}
