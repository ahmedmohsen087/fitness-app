import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/api/request_models/change_password_request_model.dart';
import 'package:fitness_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:fitness_app/features/profile/data/models/change_password_response_model.dart';
import 'package:fitness_app/features/profile/data/models/profile_response_model.dart';
import 'package:fitness_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepositoryContract)
class ProfileRepositoryImpl implements ProfileRepositoryContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<ProfileEntity>> getProfileData() async {
    final response = await _remoteDataSource.getProfileData();

    switch (response) {
      case SuccessBaseResponse<ProfileResponseModel>(data: final data):
        return SuccessBaseResponse<ProfileEntity>(data: data.toProfileEntity());
      case ErrorBaseResponse<ProfileResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ProfileEntity>(
          errorMessage: errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ChangePasswordEntity>> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  }) async {
    final response = await _remoteDataSource.changePassword(
      changePasswordRequestModel: changePasswordRequestModel,
    );

    switch (response) {
      case SuccessBaseResponse<ChangePasswordResponseModel>(data: final data):
        return SuccessBaseResponse<ChangePasswordEntity>(
          data: data.toEntity(),
        );
      case ErrorBaseResponse<ChangePasswordResponseModel>(
        errorMessage: final errorMessage,
      ):
        return ErrorBaseResponse<ChangePasswordEntity>(
          errorMessage: errorMessage,
        );
    }
  }
}
