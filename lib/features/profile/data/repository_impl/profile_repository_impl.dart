import 'package:dio/dio.dart';
import 'package:fitness_app/config/base_repository/base_repository.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
import 'package:fitness_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';
import '../models/change_password_response_model.dart';
import '../../api/request_models/change_password_request_model.dart';
import '../../api/request_models/edit_profile_request_model.dart';
import '../../api/request_models/upload_profile_photo_request_model.dart';
import '../../domain/entities/change_password_entity.dart';
import '../../domain/entities/edit_profile_params.dart';
import '../../domain/entities/profile_message_entity.dart';
import '../../domain/entities/upload_profile_photo_params.dart';
import '../../domain/services/profile_image_compressor_service.dart';

@Injectable(as: ProfileRepositoryContract)
class ProfileRepositoryImpl extends BaseRepository
    implements ProfileRepositoryContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;
  final ProfileImageCompressorService _imageCompressor;

  ProfileRepositoryImpl(this._remoteDataSource, this._imageCompressor);

  @override
  Future<BaseResponse<ProfileResponseEntity>> getProfileData() => execute(
    request: _remoteDataSource.getProfileData,
    mapper: (model) => model.toProfileEntity(),
  );

  @override
  Future<BaseResponse<ProfileResponseEntity>> editProfile(
    EditProfileParams params,) =>
      execute(
        request: () =>
            _remoteDataSource.editProfile(
      EditProfileRequestModel.fromParams(params),
    ),
    mapper: (model) => model.toProfileEntity(),
  );

  @override
  Future<BaseResponse<ProfileMessageEntity>> uploadProfilePhoto(
    UploadProfilePhotoParams params,) {
    return execute(
      request: () async {
        final compressedPhoto = await _imageCompressor.compress(params);
        final request = UploadProfilePhotoRequestModel(
          photo: MultipartFile.fromBytes(
            compressedPhoto.bytes,
            filename: compressedPhoto.fileName,
          ),
        );
        return _remoteDataSource.uploadProfilePhoto(request);
      },
      mapper: (model) => model.toEntity(),
      errorCode: _profilePhotoErrorCode,
    );
  }

  String? _profilePhotoErrorCode(Object error) {
    return error is ProfileImageCompressionException
        ? error.failure.name
        : null;
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
