import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:fitness_app/features/profile/data/models/profile_response_model.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
import 'package:fitness_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRepositoryContract)
class ProfileRepositoryImpl implements ProfileRepositoryContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

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
}
