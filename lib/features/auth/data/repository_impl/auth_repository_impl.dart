import 'package:injectable/injectable.dart';

import '../../../../config/auth/auth_manager.dart';
import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/register_request_model.dart';
import '../../domain/entities/register_params.dart';
import '../../domain/entities/register_response_entity.dart';
import '../../domain/repository_contract/auth_repository_contract.dart';
import '../data_sources_contract/auth_remote_data_source_contract.dart';

@Injectable(as: AuthRepositoryContract)
class AuthRepositoryImpl implements AuthRepositoryContract {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthManager _authManager;

  AuthRepositoryImpl(this._remoteDataSource, this._authManager);

  @override
  Future<BaseResponse<RegisterResponseEntity>> signUp(
    RegisterParams params,
  ) async {
    final body = RegisterRequestModel.fromParams(params);
    final response = await _remoteDataSource.signUp(body);

    switch (response) {
      case SuccessBaseResponse<dynamic>():
        final model = (response as SuccessBaseResponse).data;
        final token = model.token;

        if (token != null && token.isNotEmpty) {
          await _authManager.setAuthData(token: token);
        }

        return SuccessBaseResponse(data: model.toEntity());

      case ErrorBaseResponse<dynamic>():
        return ErrorBaseResponse(
          errorMessage: (response as ErrorBaseResponse).errorMessage,
        );
    }
  }
}
