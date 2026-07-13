import 'package:fitness_app/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/auth/auth_manager.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:fitness_app/features/auth/data/models/auth_response_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/mappers/auth_response_model_mapper.dart';
import 'package:fitness_app/features/auth/data/data_sources_contract/auth_remote_data_source_contract.dart';

@GenerateMocks([AuthRemoteDataSourceContract, AuthManager])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSourceContract mockRemoteDataSource;
  late MockAuthManager mockAuthManager;

  final tRequestModel = ForgetPasswordRequestModel(email: 'test@example.com');

  const tAuthResponseModel = AuthResponseModel(
    message: 'Success',
    token: 'mocked_jwt_token',
    info: 'Operation completed',
    status: 'success',
  );

  final tForgetEntity = tAuthResponseModel.toForgetPasswordEntity(
    step: ForgetPasswordRecoveryStep.forget,
  );
  final tVerifyEntity = tAuthResponseModel.toForgetPasswordEntity(
    step: ForgetPasswordRecoveryStep.verify,
  );
  final tResetEntity = tAuthResponseModel.toForgetPasswordEntity(
    step: ForgetPasswordRecoveryStep.reset,
  );

  const tErrorMessage = 'Something went wrong';

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSourceContract();
    mockAuthManager = MockAuthManager();
    repository = AuthRepositoryImpl(mockRemoteDataSource, mockAuthManager);

    provideDummy<BaseResponse<AuthResponseModel>>(
      SuccessBaseResponse<AuthResponseModel>(data: tAuthResponseModel),
    );
  });

  group('forgetPassword Tests', () {
    test(
      'should return SuccessBaseResponse holding ForgetPasswordEntity mapped with step.forget when remote data source succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.forgetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async =>
              SuccessBaseResponse<AuthResponseModel>(data: tAuthResponseModel),
        );

        // Act
        final result = await repository.forgetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect((result as SuccessBaseResponse).data, tForgetEntity);
        verify(
          mockRemoteDataSource.forgetPassword(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse holding the exact error message when remote data source fails',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.forgetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async =>
              ErrorBaseResponse<AuthResponseModel>(errorMessage: tErrorMessage),
        );

        // Act
        final result = await repository.forgetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect((result as ErrorBaseResponse).errorMessage, tErrorMessage);
        verify(
          mockRemoteDataSource.forgetPassword(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );
  });

  group('verifyOtp Tests', () {
    test(
      'should return SuccessBaseResponse holding ForgetPasswordEntity mapped with step.verify when remote data source succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.verifyOtp(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async =>
              SuccessBaseResponse<AuthResponseModel>(data: tAuthResponseModel),
        );

        // Act
        final result = await repository.verifyOtp(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect((result as SuccessBaseResponse).data, tVerifyEntity);
        verify(
          mockRemoteDataSource.verifyOtp(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse when verifyOtp on remote data source fails',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.verifyOtp(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async =>
              ErrorBaseResponse<AuthResponseModel>(errorMessage: tErrorMessage),
        );

        // Act
        final result = await repository.verifyOtp(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect((result as ErrorBaseResponse).errorMessage, tErrorMessage);
        verify(
          mockRemoteDataSource.verifyOtp(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );
  });

  group('resetPassword Tests', () {
    test(
      'should return SuccessBaseResponse holding ForgetPasswordEntity mapped with step.reset when remote data source succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.resetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async =>
              SuccessBaseResponse<AuthResponseModel>(data: tAuthResponseModel),
        );

        // Act
        final result = await repository.resetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect((result as SuccessBaseResponse).data, tResetEntity);
        verify(
          mockRemoteDataSource.resetPassword(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse when resetPassword on remote data source fails',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.resetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async =>
              ErrorBaseResponse<AuthResponseModel>(errorMessage: tErrorMessage),
        );

        // Act
        final result = await repository.resetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect((result as ErrorBaseResponse).errorMessage, tErrorMessage);
        verify(
          mockRemoteDataSource.resetPassword(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );
  });
}
