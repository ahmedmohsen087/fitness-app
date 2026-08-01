import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';
import '../entities/chat_session_entity.dart';
import '../repository_contract/smart_coach_repository_contract.dart';

@injectable
class GetSmartCoachHistoryUseCase {
  final SmartCoachRepositoryContract _repository;

  const GetSmartCoachHistoryUseCase(this._repository);

  Future<BaseResponse<List<ChatSessionEntity>>> execute() {
    return _repository.getChatHistory();
  }
}
