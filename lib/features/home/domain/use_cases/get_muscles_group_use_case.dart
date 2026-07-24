import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/muscles_group/muscles_group_entity.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetMusclesGroupUseCase {
  final HomeRepositoryContract _homeRepository;

  GetMusclesGroupUseCase(this._homeRepository);

  Future<BaseResponse<MusclesGroupEntity>> execute() {
    return _homeRepository.getMusclesGroup();
  }
}
