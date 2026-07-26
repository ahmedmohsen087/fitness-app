import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
import 'package:fitness_app/features/profile/domain/repository_contract/profile_repository_contract.dart';
import 'package:fitness_app/features/profile/domain/use_cases/get_profile_data_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_data_usecase_test.mocks.dart';

@GenerateMocks([ProfileRepositoryContract])
void main() {
  late MockProfileRepositoryContract repository;

  setUpAll(() {
    provideDummy<BaseResponse<ProfileResponseEntity>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
  });

  setUp(() => repository = MockProfileRepositoryContract());

  test('GetProfileDataUseCase delegates unchanged on failure', () async {
    final expected = ErrorBaseResponse<ProfileResponseEntity>(
      errorMessage: 'failed',
    );
    when(repository.getProfileData()).thenAnswer((_) async => expected);

    final result = await GetProfileDataUseCase(repository).getProfileData();

    expect(result, same(expected));
    verify(repository.getProfileData()).called(1);
  });

  test(
    'GetProfileDataUseCase throws exception when repository throws',
    () async {
      when(repository.getProfileData()).thenThrow(Exception('Server Error'));

      final call = GetProfileDataUseCase(repository).getProfileData;

      expect(() => call(), throwsA(isA<Exception>()));
      verify(repository.getProfileData()).called(1);
    },
  );
}
