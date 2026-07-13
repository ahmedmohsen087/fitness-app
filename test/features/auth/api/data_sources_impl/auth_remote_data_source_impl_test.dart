import 'package:fitness_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:fitness_app/features/auth/api/data_sources_impl/auth_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/utils/error/error_handler.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:fitness_app/features/auth/data/models/auth_response_model.dart';

@GenerateMocks([AuthApiClient])
import 'auth_remote_data_source_impl_test.mocks.dart';

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockAuthApiClient mockApiClient;

  final tRequestModel = ForgetPasswordRequestModel(email: 'test@example.com');

  const tAuthResponseModel = AuthResponseModel(
    message: 'Success',
    token: 'mocked_jwt_token_here',
    info: 'Operation completed successfully',
    status: 'success',
  );

  setUp(() {
    mockApiClient = MockAuthApiClient();
    dataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  group('forgetPassword Tests', () {
    test(
      'should return SuccessBaseResponse containing AuthResponseModel when the call to api client is successful',
      () async {
        // Arrange
        when(
          mockApiClient.forgetPassword(any),
        ).thenAnswer((_) async => tAuthResponseModel);

        // Act
        final result = await dataSource.forgetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<AuthResponseModel>>());
        expect((result as SuccessBaseResponse).data, tAuthResponseModel);
        verify(mockApiClient.forgetPassword(tRequestModel)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return ErrorBaseResponse when the call to api client throws an exception',
      () async {
        // Arrange
        final tException = Exception('Server Error');
        when(mockApiClient.forgetPassword(any)).thenThrow(tException);

        // Act
        final result = await dataSource.forgetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<AuthResponseModel>>());
        expect(
          (result as ErrorBaseResponse).errorMessage,
          ErrorHandler.handle(tException),
        );
        verify(mockApiClient.forgetPassword(tRequestModel)).called(1);
      },
    );
  });

  group('verifyOtp Tests', () {
    test(
      'should return SuccessBaseResponse when verifyOtp is successful',
      () async {
        // Arrange
        when(
          mockApiClient.verifyOtp(any),
        ).thenAnswer((_) async => tAuthResponseModel);

        // Act
        final result = await dataSource.verifyOtp(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<AuthResponseModel>>());
        expect((result as SuccessBaseResponse).data, tAuthResponseModel);
        verify(mockApiClient.verifyOtp(tRequestModel)).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse when verifyOtp throws an exception',
      () async {
        // Arrange
        final tException = Exception('Invalid OTP');
        when(mockApiClient.verifyOtp(any)).thenThrow(tException);

        // Act
        final result = await dataSource.verifyOtp(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<AuthResponseModel>>());
        expect(
          (result as ErrorBaseResponse).errorMessage,
          ErrorHandler.handle(tException),
        );
        verify(mockApiClient.verifyOtp(tRequestModel)).called(1);
      },
    );
  });

  group('resetPassword Tests', () {
    test(
      'should return SuccessBaseResponse when resetPassword is successful',
      () async {
        // Arrange
        when(
          mockApiClient.resetPassword(any),
        ).thenAnswer((_) async => tAuthResponseModel);

        // Act
        final result = await dataSource.resetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<AuthResponseModel>>());
        expect((result as SuccessBaseResponse).data, tAuthResponseModel);
        verify(mockApiClient.resetPassword(tRequestModel)).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse when resetPassword throws an exception',
      () async {
        // Arrange
        final tException = Exception('Weak Password');
        when(mockApiClient.resetPassword(any)).thenThrow(tException);

        // Act
        final result = await dataSource.resetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<AuthResponseModel>>());
        expect(
          (result as ErrorBaseResponse).errorMessage,
          ErrorHandler.handle(tException),
        );
        verify(mockApiClient.resetPassword(tRequestModel)).called(1);
      },
    );
  });
}
