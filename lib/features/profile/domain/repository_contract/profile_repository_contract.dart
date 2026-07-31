import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/api/request_models/change_password_request_model.dart';
import 'package:fitness_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';

abstract interface class ProfileRepositoryContract {
  Future<BaseResponse<ProfileEntity>> getProfileData();

  Future<BaseResponse<ChangePasswordEntity>> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  });
}
