import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/utils/error/error_handler.dart';
import 'package:fitness_app/features/profile/api/api_client/profile_api_client.dart';
import 'package:fitness_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:fitness_app/features/profile/data/models/profile_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/change_password_response_model.dart';
import '../models/profile_message_model.dart';
import '../request_models/change_password_request_model.dart';
import '../request_models/edit_profile_request_model.dart';
import '../request_models/upload_profile_photo_request_model.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient _profileApiClient;

  ProfileRemoteDataSourceImpl(this._profileApiClient);

  @override
  Future<BaseResponse<ProfileResponseModel>> getProfileData() async {
    try {
      final response = await _profileApiClient.getProfileData();
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(e));
    }
  }

  @override
  Future<BaseResponse<ProfileResponseModel>> editProfile(
    EditProfileRequestModel body,
  ) async {
    try {
      final response = await _profileApiClient.editProfile(body);
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(e));
    }
  }

  @override
  Future<BaseResponse<ProfileMessageModel>> uploadProfilePhoto(
    UploadProfilePhotoRequestModel body,
  ) async {
    try {
      final response = await _profileApiClient.uploadProfilePhoto(body.photo);
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(e));
    }
  }

  @override
  Future<BaseResponse<ChangePasswordResponseModel>> changePassword(
    ChangePasswordRequestModel body,
  ) async {
    try {
      final response = await _profileApiClient.changePassword(body);
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(e));
    }
  }
}
