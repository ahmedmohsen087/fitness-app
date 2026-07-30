import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_group_entity.dart';
import 'package:fitness_app/features/fitness/domain/repository_contract/fitness_repository_contract.dart';
import 'package:fitness_app/features/fitness/domain/use_cases/get_muscles_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_muscles_use_case_test.mocks.dart';

@GenerateMocks([FitnessRepositoryContract])
void main() {
  late GetMusclesUseCase useCase;
  late MockFitnessRepositoryContract mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<List<MuscleGroupEntity>>>(
      ErrorBaseResponse(errorMessage: 'dummy'),
    );
  });

  setUp(() {
    mockRepository = MockFitnessRepositoryContract();
    useCase = GetMusclesUseCase(mockRepository);
  });

  test('should return list of MuscleGroupEntity on success', () async {
    const tList = [MuscleGroupEntity(id: '1', name: 'Chest')];
    when(mockRepository.getMuscleGroups())
        .thenAnswer((_) async => SuccessBaseResponse(data: tList));

    final result = await useCase.execute();

    expect(result, isA<SuccessBaseResponse<List<MuscleGroupEntity>>>());
    expect((result as SuccessBaseResponse<List<MuscleGroupEntity>>).data, tList);
    verify(mockRepository.getMuscleGroups());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ErrorBaseResponse on failure', () async {
    when(mockRepository.getMuscleGroups())
        .thenAnswer((_) async => ErrorBaseResponse(errorMessage: 'Error'));

    final result = await useCase.execute();

    expect(result, isA<ErrorBaseResponse<List<MuscleGroupEntity>>>());
    expect((result as ErrorBaseResponse<List<MuscleGroupEntity>>).errorMessage, 'Error');
    verify(mockRepository.getMuscleGroups());
    verifyNoMoreInteractions(mockRepository);
  });
}
