import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';

abstract interface class ProfileRepositoryContract {
  Future<BaseResponse<ProfileEntity>> getProfileData();
}
