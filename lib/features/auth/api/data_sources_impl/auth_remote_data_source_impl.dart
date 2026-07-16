import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../core/utils/error/error_handler.dart';
import '../../api/models/register_response_model.dart';
import '../../api/request_models/register_request_model.dart';
import '../../data/data_sources_contract/auth_remote_data_source_contract.dart';
import '../api_client/auth_api_client.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<BaseResponse<RegisterResponseModel>> signUp(
    RegisterRequestModel body,
  ) async {
    try {
      final response = await _authApiClient.signUp(body);
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: ErrorHandler.handle(e));
    }
  }
}
