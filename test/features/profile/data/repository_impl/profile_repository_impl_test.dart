import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/values/register_constants.dart';
import 'package:fitness_app/features/auth/data/models/login_user_dto.dart';
import 'package:fitness_app/features/profile/api/models/profile_message_model.dart';
import 'package:fitness_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:fitness_app/features/profile/api/request_models/upload_profile_photo_request_model.dart';
import 'package:fitness_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:fitness_app/features/profile/data/models/profile_response_model.dart';
import 'package:fitness_app/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:fitness_app/features/profile/domain/entities/compressed_profile_photo_entity.dart';
import 'package:fitness_app/features/profile/domain/entities/edit_profile_params.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_message_entity.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
import 'package:fitness_app/features/profile/domain/entities/upload_profile_photo_params.dart';
import 'package:fitness_app/features/profile/domain/repository_contract/profile_image_compressor_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repository_impl_test.mocks.dart';

@GenerateMocks([
  ProfileRemoteDataSourceContract,
  ProfileImageCompressorContract,
])
void main() {
  late MockProfileRemoteDataSourceContract remoteDataSource;
  late MockProfileImageCompressorContract imageCompressor;
  late ProfileRepositoryImpl repository;

  setUpAll(() {
    provideDummy<BaseResponse<ProfileResponseModel>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<ProfileMessageModel>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
    provideDummy(_editRequest);
    provideDummy(
      UploadProfilePhotoRequestModel(photo: MultipartFile.fromBytes(const [])),
    );
    provideDummy(_photoParams);
    provideDummy(
      CompressedProfilePhotoEntity(bytes: Uint8List(0), fileName: 'photo.jpg'),
    );
  });

  setUp(() {
    remoteDataSource = MockProfileRemoteDataSourceContract();
    imageCompressor = MockProfileImageCompressorContract();
    repository = ProfileRepositoryImpl(remoteDataSource, imageCompressor);
  });

  test('editProfile serializes typed values and maps the response', () async {
    final model = ProfileResponseModel(
      message: 'success',
      user: LoginUserDto(
        id: '1',
        firstName: 'First',
        lastName: 'Last',
        email: 'first@example.com',
        weight: 70,
        goal: 'Gain weight',
        activityLevel: 'level1',
        createdAt: DateTime(2026),
      ),
    );
    when(
      remoteDataSource.editProfile(any),
    ).thenAnswer((_) async => SuccessBaseResponse(data: model));

    final result = await repository.editProfile(_editParams);

    expect(result, isA<SuccessBaseResponse<ProfileResponseEntity>>());
    final request =
        verify(remoteDataSource.editProfile(captureAny)).captured.single
            as EditProfileRequestModel;
    expect(request.goal, 'Gain weight');
    expect(request.activityLevel, 'level1');
  });

  test(
    'uploadProfilePhoto compresses before creating multipart data',
    () async {
      when(imageCompressor.compress(_photoParams)).thenAnswer(
        (_) async => CompressedProfilePhotoEntity(
          bytes: Uint8List.fromList(const [1, 2, 3]),
          fileName: 'photo.jpg',
        ),
      );
      when(remoteDataSource.uploadProfilePhoto(any)).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const ProfileMessageModel(message: 'success'),
        ),
      );

      final result = await repository.uploadProfilePhoto(_photoParams);

      expect(result, isA<SuccessBaseResponse<ProfileMessageEntity>>());
      final request =
          verify(
                remoteDataSource.uploadProfilePhoto(captureAny),
              ).captured.single
              as UploadProfilePhotoRequestModel;
      expect(request.photo.length, 3);
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

final _editRequest = EditProfileRequestModel.fromParams(_editParams);

const _photoParams = UploadProfilePhotoParams(
  path: 'photo.jpg',
  fileName: 'photo.jpg',
);
