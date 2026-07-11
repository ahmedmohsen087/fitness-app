import 'package:injectable/injectable.dart';

import '../../../../config/auth/auth_manager.dart';
import '../../domain/repository_contract/auth_repository_contract.dart';
import '../data_sources_contract/auth_remote_data_source_contract.dart';

@Injectable(as: AuthRepositoryContract)
class AuthRepositoryImpl implements AuthRepositoryContract {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthManager _authManager;
  AuthRepositoryImpl(this._remoteDataSource, this._authManager);


}
