import 'package:dio/dio.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/utils/error/error_handler.dart';
import 'package:fitness_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:fitness_app/features/profile/data/models/profile_response_model.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
import 'package:fitness_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';

import '../models/change_password_response_model.dart';
import '../../api/models/profile_message_model.dart';
import '../../api/request_models/change_password_request_model.dart';
import '../../api/request_models/edit_profile_request_model.dart';
import '../../api/request_models/upload_profile_photo_request_model.dart';
import '../../domain/entities/change_password_entity.dart';
import '../../domain/entities/edit_profile_params.dart';
import '../../domain/entities/profile_message_entity.dart';
import '../../domain/entities/upload_profile_photo_params.dart';
import '../../domain/repository_contract/profile_image_compressor_contract.dart';

@Injectable(as: ProfileRepositoryContract)
class ProfileRepositoryImpl implements ProfileRepositoryContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;
  final ProfileImageCompressorContract _imageCompressor;

  ProfileRepositoryImpl(this._remoteDataSource, this._imageCompressor);

  @override
  Future<BaseResponse<ProfileResponseEntity>> getProfileData() async {
    final response = await _remoteDataSource.getProfileData();

    switch (response) {
      case SuccessBaseResponse<ProfileResponseModel>(data: final data):
        final entity = data.toProfileEntity();
        return SuccessBaseResponse<ProfileResponseEntity>(data: entity);
      case ErrorBaseResponse<ProfileResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ProfileResponseEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ProfileResponseEntity>> editProfile(
    EditProfileParams params,
  ) async {
    final response = await _remoteDataSource.editProfile(
      EditProfileRequestModel.fromParams(params),
    );

    switch (response) {
      case SuccessBaseResponse<ProfileResponseModel>(data: final data):
        return SuccessBaseResponse(data: data.toProfileEntity());
      case ErrorBaseResponse<ProfileResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse(errorMessage: errorMessage);
    }
  }

  @override
  Future<BaseResponse<ProfileMessageEntity>> uploadProfilePhoto(
    UploadProfilePhotoParams params,
  ) async {
    try {
      final compressedPhoto = await _imageCompressor.compress(params);
      final request = UploadProfilePhotoRequestModel(
        photo: MultipartFile.fromBytes(
          compressedPhoto.bytes,
          filename: compressedPhoto.fileName,
        ),
      );
      final response = await _remoteDataSource.uploadProfilePhoto(request);

      switch (response) {
        case SuccessBaseResponse<ProfileMessageModel>(data: final data):
          return SuccessBaseResponse(data: data.toEntity());
        case ErrorBaseResponse<ProfileMessageModel>(
          errorMessage: final errorMessage,
        ):
          return ErrorBaseResponse(errorMessage: errorMessage);
      }
    } on StateError catch (error) {
      return ErrorBaseResponse(errorMessage: error.message.toString());
    } catch (error) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(error));
    }
  }

  @override
  Future<BaseResponse<ChangePasswordEntity>> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  }) async {
    final response = await _remoteDataSource.changePassword(
      changePasswordRequestModel,
    );

    switch (response) {
      case SuccessBaseResponse<ChangePasswordResponseModel>(data: final data):
        return SuccessBaseResponse<ChangePasswordEntity>(data: data.toEntity());
      case ErrorBaseResponse<ChangePasswordResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ChangePasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }
}
