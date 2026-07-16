import 'package:dio/dio.dart';
import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:fitness_app/features/auth/api/data_sources_impl/auth_remote_data_source_impl.dart';
import 'package:fitness_app/features/auth/api/models/register_response_model.dart';
import 'package:fitness_app/features/auth/api/models/user_model.dart';
import 'package:fitness_app/features/auth/api/request_models/register_request_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApiClient])
void main() {
  late MockAuthApiClient mockAuthApiClient;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockAuthApiClient = MockAuthApiClient();
    dataSource = AuthRemoteDataSourceImpl(mockAuthApiClient);
  });

  final tRegisterRequestModel = RegisterRequestModel(
    firstName: 'Elevate',
    lastName: 'Tech',
    email: 'test@test.com',
    password: 'Test@123',
    rePassword: 'Test@123',
    gender: 'male',
    height: 170,
    weight: 70,
    age: 25,
    goal: 'Gain weight',
    activityLevel: 'level1',
  );

  final tRegisterResponseModel = RegisterResponseModel(
    message: 'success',
    user: UserModel(
      id: '123',
      firstName: 'Elevate',
      lastName: 'Tech',
      email: 'test@test.com',
      gender: 'male',
      age: 25,
      weight: 70,
      height: 170,
      activityLevel: 'level1',
      goal: 'Gain weight',
      photo: 'default-profile.png',
      createdAt: '2026-07-11T12:38:57.798Z',
    ),
    token: 'test_token',
  );

  group('signUp', () {
    test('returns SuccessBaseResponse when API call succeeds', () async {
      when(
        mockAuthApiClient.signUp(tRegisterRequestModel),
      ).thenAnswer((_) async => tRegisterResponseModel);

      final result = await dataSource.signUp(tRegisterRequestModel);

      expect(result, isA<SuccessBaseResponse<RegisterResponseModel>>());
      final success = result as SuccessBaseResponse<RegisterResponseModel>;
      expect(success.data.token, 'test_token');
      expect(success.data.message, 'success');
    });

    test(
      'returns ErrorBaseResponse when API call throws DioException',
      () async {
        when(mockAuthApiClient.signUp(tRegisterRequestModel)).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionError,
          ),
        );

        final result = await dataSource.signUp(tRegisterRequestModel);

        expect(result, isA<ErrorBaseResponse<RegisterResponseModel>>());
      },
    );

    test(
      'returns ErrorBaseResponse when API call throws generic exception',
      () async {
        when(
          mockAuthApiClient.signUp(tRegisterRequestModel),
        ).thenThrow(Exception('Unexpected error'));

        final result = await dataSource.signUp(tRegisterRequestModel);

        expect(result, isA<ErrorBaseResponse<RegisterResponseModel>>());
      },
    );
  });
}
