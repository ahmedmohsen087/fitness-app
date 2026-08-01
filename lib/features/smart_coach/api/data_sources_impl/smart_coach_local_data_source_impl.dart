import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources_contract/smart_coach_local_data_source_contract.dart';
import '../../data/models/chat_action_model.dart';
import '../../data/models/chat_action_params_model.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/chat_session_model.dart';

@Injectable(as: SmartCoachLocalDataSourceContract)
class SmartCoachLocalDataSourceImpl
    implements SmartCoachLocalDataSourceContract {
  static const String _boxName = 'smart_coach_sessions';

  SmartCoachLocalDataSourceImpl() {
    _registerAdapters();
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ChatMessageModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ChatActionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ChatSessionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ChatActionParamsModelAdapter());
    }
  }

  Future<Box<ChatSessionModel>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<ChatSessionModel>(_boxName);
    }
    try {
      return await Hive.openBox<ChatSessionModel>(_boxName);
    } catch (_) {
      await Hive.deleteBoxFromDisk(_boxName);
      return await Hive.openBox<ChatSessionModel>(_boxName);
    }
  }

  @override
  Future<BaseResponse<List<ChatSessionModel>>> getChatSessions() async {
    try {
      final box = await _getBox();
      final sessions = box.values.toList()
        ..sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
      return SuccessBaseResponse(data: sessions);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: e.toString());
    }
  }

  @override
  Future<BaseResponse<void>> saveChatSession(ChatSessionModel session) async {
    try {
      final box = await _getBox();
      await box.put(session.sessionId, session);
      return SuccessBaseResponse(data: null);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: e.toString());
    }
  }

  @override
  Future<BaseResponse<void>> deleteChatSession(String sessionId) async {
    try {
      final box = await _getBox();
      await box.delete(sessionId);
      return SuccessBaseResponse(data: null);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: e.toString());
    }
  }
}
