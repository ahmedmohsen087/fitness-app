import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:fitness_app/features/auth/api/data_sources_impl/auth_remote_data_source_impl.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_email_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/data/models/forget_password_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<AuthApiClient>()])
import 'auth_remote_data_source_impl_test.mocks.dart';

void main() {
  late MockAuthApiClient mockApiClient;
  late AuthRemoteDataSourceImpl dataSource;

  const forgetPasswordRequest = ForgetPasswordEmailRequestModel(
    email: 'test@test.com',
  );
  const verifyOtpRequest = VerifyResetCodeRequestModel(resetCode: '1234');
  const resetPasswordRequest = ResetPasswordRequestModel(
    password: 'oldPass1!',
    newPassword: 'newPass1!',
  );

  setUp(() {
    mockApiClient = MockAuthApiClient();
    dataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  group('forgetPassword', () {
    test(
      'returns SuccessBaseResponse with a ForgetPasswordResponseModel',
      () async {
        final result = await dataSource.forgetPassword(
          forgetPasswordEmailRequestModel: forgetPasswordRequest,
        );

        expect(result, isA<SuccessBaseResponse<ForgetPasswordResponseModel>>());
        final data =
            (result as SuccessBaseResponse<ForgetPasswordResponseModel>).data;
        expect(data.message, isNull);
        expect(data.token, isNull);
        expect(data.status, isNull);
      },
    );

    // The real Dio call is currently disabled inside the implementation,
    // so the injected AuthApiClient is never actually invoked.
    test('does not invoke AuthApiClient.forgetPassword', () async {
      await dataSource.forgetPassword(
        forgetPasswordEmailRequestModel: forgetPasswordRequest,
      );

      verifyNever(mockApiClient.forgetPassword(any));
    });
  });

  group('verifyOtp', () {
    test(
      'returns SuccessBaseResponse with a ForgetPasswordResponseModel',
      () async {
        final result = await dataSource.verifyOtp(
          verifyResetCodeRequestModel: verifyOtpRequest,
        );

        expect(result, isA<SuccessBaseResponse<ForgetPasswordResponseModel>>());
      },
    );

    test('does not invoke AuthApiClient.verifyOtp', () async {
      await dataSource.verifyOtp(verifyResetCodeRequestModel: verifyOtpRequest);

      verifyNever(mockApiClient.verifyOtp(any));
    });
  });

  group('resetPassword', () {
    test(
      'returns SuccessBaseResponse with a ForgetPasswordResponseModel',
      () async {
        final result = await dataSource.resetPassword(
          resetPasswordRequestModel: resetPasswordRequest,
        );

        expect(result, isA<SuccessBaseResponse<ForgetPasswordResponseModel>>());
      },
    );

    test('does not invoke AuthApiClient.resetPassword', () async {
      await dataSource.resetPassword(
        resetPasswordRequestModel: resetPasswordRequest,
      );

      verifyNever(mockApiClient.resetPassword(any));
    });
  });
}
