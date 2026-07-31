import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/data/models/profile_response_model.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<BaseResponse<ProfileResponseModel>> getProfileData();
}
