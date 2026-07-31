import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/api/request_models/change_password_request_model.dart';
import 'package:fitness_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:fitness_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:fitness_app/features/profile/domain/use_cases/change_password_use_case.dart';

import 'change_password_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepositoryContract])
void main() {
  late ChangePasswordUseCase changePasswordUseCase;
  late MockProfileRepositoryContract mockProfileRepositoryContract;

  setUp(() {
    mockProfileRepositoryContract = MockProfileRepositoryContract();
    changePasswordUseCase = ChangePasswordUseCase(
      mockProfileRepositoryContract,
    );

    provideDummy<BaseResponse<ChangePasswordEntity>>(
      SuccessBaseResponse(data: ChangePasswordEntity()),
    );
  });

  group('ChangePasswordUseCase Unit Tests', () {
    final tRequestModel = ChangePasswordRequestModel(
      password: 'OldPassword123',
      newPassword: 'NewPassword123',
    );

    final tEntity = ChangePasswordEntity();
    final tSuccessResponse = SuccessBaseResponse<ChangePasswordEntity>(
      data: tEntity,
    );

    test(
      'should call changePassword on repository contract and return SuccessBaseResponse',
      () async {
        // Arrange
        when(
          mockProfileRepositoryContract.changePassword(
            changePasswordRequestModel: anyNamed('changePasswordRequestModel'),
          ),
        ).thenAnswer((_) async => tSuccessResponse);

        // Act
        final result = await changePasswordUseCase.execute(
          changePasswordRequestModel: tRequestModel,
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<ChangePasswordEntity>>());
        expect(
          (result as SuccessBaseResponse<ChangePasswordEntity>).data,
          equals(tEntity),
        );
        verify(
          mockProfileRepositoryContract.changePassword(
            changePasswordRequestModel: tRequestModel,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockProfileRepositoryContract);
      },
    );

    test('should return ErrorBaseResponse when repository fails', () async {
      // Arrange
      final tErrorResponse = ErrorBaseResponse<ChangePasswordEntity>(
        errorMessage: 'Error',
      );

      when(
        mockProfileRepositoryContract.changePassword(
          changePasswordRequestModel: anyNamed('changePasswordRequestModel'),
        ),
      ).thenAnswer((_) async => tErrorResponse);

      // Act
      final result = await changePasswordUseCase.execute(
        changePasswordRequestModel: tRequestModel,
      );

      // Assert
      expect(result, isA<ErrorBaseResponse<ChangePasswordEntity>>());
      expect(
        (result as ErrorBaseResponse<ChangePasswordEntity>).errorMessage,
        equals('Error'),
      );
      verify(
        mockProfileRepositoryContract.changePassword(
          changePasswordRequestModel: tRequestModel,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockProfileRepositoryContract);
    });
  });
}
