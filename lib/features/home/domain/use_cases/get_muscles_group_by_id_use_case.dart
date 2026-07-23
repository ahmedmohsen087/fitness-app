import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/muscles_group/muscles_group_by_id_entity.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetMusclesGroupByIdUseCase {
  final HomeRepositoryContract _homeRepository;

  GetMusclesGroupByIdUseCase(this._homeRepository);

  Future<BaseResponse<MusclesGroupByIdEntity>> execute(String id) {
    return _homeRepository.getMusclesGroupId(id);
  }
}
