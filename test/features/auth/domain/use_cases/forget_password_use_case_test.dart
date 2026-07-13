import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/request_models/forget_password_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/domain/repository_contract/auth_repository_contract.dart';
import 'package:fitness_app/features/auth/domain/use_cases/forget_password_use_case.dart';

@GenerateMocks([AuthRepositoryContract])
import 'forget_password_use_case_test.mocks.dart';

void main() {
  late ForgetPasswordUseCase useCase;
  late MockAuthRepositoryContract mockAuthRepository;

  final tRequestModel = ForgetPasswordRequestModel(email: 'test@example.com');

  const tForgetPasswordEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forget,
    message: 'Success',
    info: 'Operation completed',
    status: 'success',
  );

  const tErrorMessage = 'An error occurred';

  setUp(() {
    mockAuthRepository = MockAuthRepositoryContract();
    useCase = ForgetPasswordUseCase(mockAuthRepository);

    provideDummy<BaseResponse<ForgetPasswordEntity>>(
      SuccessBaseResponse<ForgetPasswordEntity>(data: tForgetPasswordEntity),
    );
  });

  group('forgetPassword Tests', () {
    test(
      'should return SuccessBaseResponse from repository when forgetPassword is called',
      () async {
        // Arrange
        when(
          mockAuthRepository.forgetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordEntity>(
            data: tForgetPasswordEntity,
          ),
        );

        // Act
        final result = await useCase.forgetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect((result as SuccessBaseResponse).data, tForgetPasswordEntity);
        verify(
          mockAuthRepository.forgetPassword(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse from repository when forgetPassword fails',
      () async {
        // Arrange
        when(
          mockAuthRepository.forgetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<ForgetPasswordEntity>(
            errorMessage: tErrorMessage,
          ),
        );

        // Act
        final result = await useCase.forgetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect((result as ErrorBaseResponse).errorMessage, tErrorMessage);
        verify(
          mockAuthRepository.forgetPassword(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );
  });

  group('verifyOtp Tests', () {
    test(
      'should return SuccessBaseResponse from repository when verifyOtp is called',
      () async {
        // Arrange
        when(
          mockAuthRepository.verifyOtp(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordEntity>(
            data: tForgetPasswordEntity,
          ),
        );

        // Act
        final result = await useCase.verifyOtp(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect((result as SuccessBaseResponse).data, tForgetPasswordEntity);
        verify(
          mockAuthRepository.verifyOtp(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse from repository when verifyOtp fails',
      () async {
        // Arrange
        when(
          mockAuthRepository.verifyOtp(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<ForgetPasswordEntity>(
            errorMessage: tErrorMessage,
          ),
        );

        // Act
        final result = await useCase.verifyOtp(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect((result as ErrorBaseResponse).errorMessage, tErrorMessage);
        verify(
          mockAuthRepository.verifyOtp(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );
  });

  group('resetPassword Tests', () {
    test(
      'should return SuccessBaseResponse from repository when resetPassword is called',
      () async {
        // Arrange
        when(
          mockAuthRepository.resetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<ForgetPasswordEntity>(
            data: tForgetPasswordEntity,
          ),
        );

        // Act
        final result = await useCase.resetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect((result as SuccessBaseResponse).data, tForgetPasswordEntity);
        verify(
          mockAuthRepository.resetPassword(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse from repository when resetPassword fails',
      () async {
        // Arrange
        when(
          mockAuthRepository.resetPassword(
            forgetPasswordRequestModel: anyNamed('forgetPasswordRequestModel'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<ForgetPasswordEntity>(
            errorMessage: tErrorMessage,
          ),
        );

        // Act
        final result = await useCase.resetPassword(
          forgetPasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect((result as ErrorBaseResponse).errorMessage, tErrorMessage);
        verify(
          mockAuthRepository.resetPassword(
            forgetPasswordRequestModel: tRequestModel,
          ),
        ).called(1);
      },
    );
  });
}
