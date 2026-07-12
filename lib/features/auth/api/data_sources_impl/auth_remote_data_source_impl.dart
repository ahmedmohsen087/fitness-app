import 'package:fitness_app/features/auth/data/models/login_response.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../../../core/utils/error/error_handler.dart';
import '../../data/data_sources_contract/auth_remote_data_source_contract.dart';
import '../api_client/auth_api_client.dart';
import '../request_models/login_request_model.dart';


@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<BaseResponse<LoginResponse>> login({
    required LoginRequestModel loginRequestModel,
  }) async {
    try {
      final response = await _authApiClient.login(loginRequestModel);
      return SuccessBaseResponse<LoginResponse>(data: response);
    } catch (e) {
      final message = ErrorHandler.handle(e);
      return ErrorBaseResponse<LoginResponse>(errorMessage: message);
    }
  }




}
