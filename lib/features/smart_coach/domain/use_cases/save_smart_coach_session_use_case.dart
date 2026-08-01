import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';
import '../entities/chat_session_entity.dart';
import '../repository_contract/smart_coach_repository_contract.dart';

@injectable
class SaveSmartCoachSessionUseCase {
  final SmartCoachRepositoryContract _repository;

  const SaveSmartCoachSessionUseCase(this._repository);

  Future<BaseResponse<void>> execute(ChatSessionEntity session) {
    return _repository.saveChatSession(session);
  }
}
