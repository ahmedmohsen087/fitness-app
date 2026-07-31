import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfileDataUseCase {
  final ProfileRepositoryContract _profileRepositoryContract;

  GetProfileDataUseCase(this._profileRepositoryContract);

  Future<BaseResponse<ProfileEntity>> getProfileData() {
    return _profileRepositoryContract.getProfileData();
  }
}
