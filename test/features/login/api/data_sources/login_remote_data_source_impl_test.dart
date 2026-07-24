import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:fitness_app/features/auth/api/data_sources_impl/auth_remote_data_source_impl.dart';
import 'package:fitness_app/features/auth/api/request_models/login_request_model.dart';
import 'package:fitness_app/features/auth/data/models/login_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApiClient])
void main() {
  late MockAuthApiClient mockApiClient;
  late AuthRemoteDataSourceImpl datasource;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tLoginRequestModel = LoginRequestModel(
    email: tEmail,
    password: tPassword,
  );

  final tAuthResponse = LoginResponse(
    token: 'mocked_jwt_token_for_testing',
    message: 'Success',
  );

  setUpAll(() {
    provideDummy<BaseResponse<LoginResponse>>(
      SuccessBaseResponse(data: LoginResponse()),
    );
  });

  setUp(() {
    mockApiClient = MockAuthApiClient();
    datasource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  group('login', () {
    test(
      'should return SuccessBaseResponse when api client login call succeeds',
      () async {
        // Arrange
        when(mockApiClient.login(any)).thenAnswer((_) async => tAuthResponse);

        // Act
        final result = await datasource.login(
          loginRequestModel: tLoginRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<LoginResponse>>());
        expect(
          (result as SuccessBaseResponse<LoginResponse>).data,
          tAuthResponse,
        );
        verify(mockApiClient.login(any)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return ErrorBaseResponse when api client login call fails',
      () async {
        // Arrange
        final exception = Exception('Invalid Credentials');
        when(mockApiClient.login(any)).thenThrow(exception);

        // Act
        final result = await datasource.login(
          loginRequestModel: tLoginRequestModel,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<LoginResponse>>());
        verify(mockApiClient.login(any)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });
}
