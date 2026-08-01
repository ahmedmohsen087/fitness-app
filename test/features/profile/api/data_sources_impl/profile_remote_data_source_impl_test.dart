import 'package:dio/dio.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/values/register_constants.dart';
import 'package:fitness_app/features/profile/api/api_client/profile_api_client.dart';
import 'package:fitness_app/features/profile/api/data_sources_impl/profile_remote_data_source_impl.dart';
import 'package:fitness_app/features/profile/api/models/profile_message_model.dart';
import 'package:fitness_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:fitness_app/features/profile/api/request_models/upload_profile_photo_request_model.dart';
import 'package:fitness_app/features/profile/data/models/profile_response_model.dart';
import 'package:fitness_app/features/profile/domain/entities/edit_profile_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  late MockProfileApiClient apiClient;
  late ProfileRemoteDataSourceImpl dataSource;

  setUpAll(() {
    provideDummy(_editBody);
    provideDummy(MultipartFile.fromBytes(const []));
  });

  setUp(() {
    apiClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(apiClient);
  });

  test('editProfile returns the decoded response on success', () async {
    final response = ProfileResponseModel(message: 'success');
    when(apiClient.editProfile(_editBody)).thenAnswer((_) async => response);

    final result = await dataSource.editProfile(_editBody);

    expect(result, isA<SuccessBaseResponse<ProfileResponseModel>>());
    expect((result as SuccessBaseResponse).data, same(response));
    verify(apiClient.editProfile(_editBody)).called(1);
  });

  test('editProfile converts Dio failures to an error response', () async {
    when(apiClient.editProfile(_editBody)).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: 'auth/editProfile'),
        type: DioExceptionType.connectionError,
      ),
    );

    final result = await dataSource.editProfile(_editBody);

    expect(result, isA<ErrorBaseResponse<ProfileResponseModel>>());
  });

  test('uploadProfilePhoto converts generic failures', () async {
    final request = UploadProfilePhotoRequestModel(
      photo: MultipartFile.fromBytes(const [1, 2, 3], filename: 'photo.jpg'),
    );
    when(apiClient.uploadProfilePhoto(request.photo)).thenThrow(Exception());

    final result = await dataSource.uploadProfilePhoto(request);

    expect(result, isA<ErrorBaseResponse<ProfileMessageModel>>());
  });
}

final _editBody = EditProfileRequestModel.fromParams(
  const EditProfileParams(
    firstName: 'First',
    lastName: 'Last',
    email: 'first@example.com',
    weight: 70,
    goal: FitnessGoal.gainWeight,
    activityLevel: ActivityLevel.level1,
  ),
);
