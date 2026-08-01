import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/values/register_constants.dart';
import 'package:fitness_app/features/profile/domain/entities/edit_profile_params.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_message_entity.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
import 'package:fitness_app/features/profile/domain/entities/upload_profile_photo_params.dart';
import 'package:fitness_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:fitness_app/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:fitness_app/features/profile/domain/use_cases/upload_profile_photo_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_actions_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepositoryContract])
void main() {
  late MockProfileRepositoryContract repository;

  setUpAll(() {
    provideDummy<BaseResponse<ProfileResponseEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<ProfileMessageEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy(_editParams);
    provideDummy(_photoParams);
  });

  setUp(() => repository = MockProfileRepositoryContract());

  test('EditProfileUseCase delegates params and response unchanged', () async {
    final expected = ErrorBaseResponse<ProfileResponseEntity>(
      errorMessage: 'failed',
    );
    when(repository.editProfile(_editParams)).thenAnswer((_) async => expected);

    final result = await EditProfileUseCase(repository).execute(_editParams);

    expect(result, same(expected));
    verify(repository.editProfile(_editParams)).called(1);
  });

  test(
    'UploadProfilePhotoUseCase delegates params and response unchanged',
    () async {
      const entity = ProfileMessageEntity(message: 'success');
      final expected = SuccessBaseResponse(data: entity);
      when(
        repository.uploadProfilePhoto(_photoParams),
      ).thenAnswer((_) async => expected);

      final result = await UploadProfilePhotoUseCase(
        repository,
      ).execute(_photoParams);

      expect(result, same(expected));
      verify(repository.uploadProfilePhoto(_photoParams)).called(1);
    },
  );
}

const _editParams = EditProfileParams(
  firstName: 'First',
  lastName: 'Last',
  email: 'first@example.com',
  weight: 70,
  goal: FitnessGoal.gainWeight,
  activityLevel: ActivityLevel.level1,
);

const _photoParams = UploadProfilePhotoParams(
  path: 'photo.jpg',
  fileName: 'photo.jpg',
);
