import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';
import 'package:fitness_app/features/profile/domain/use_cases/get_profile_data_usecase.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_session_entity.dart';
import '../../domain/entities/smart_coach_enums.dart';
import '../../domain/use_cases/get_smart_coach_history_use_case.dart';
import '../../domain/use_cases/save_smart_coach_session_use_case.dart';
import '../../domain/use_cases/send_smart_coach_message_use_case.dart';
import 'smart_coach_events.dart';
import 'smart_coach_states.dart';

@injectable
class SmartCoachViewModel extends Bloc<SmartCoachEvent, SmartCoachState> {
  final SendSmartCoachMessageUseCase _sendMessageUseCase;
  final GetSmartCoachHistoryUseCase _getHistoryUseCase;
  final SaveSmartCoachSessionUseCase _saveSessionUseCase;
  final GetProfileViewModel _profileViewModel;
  final GetProfileDataUseCase _getProfileDataUseCase;

  SmartCoachViewModel(
    this._sendMessageUseCase,
    this._getHistoryUseCase,
    this._saveSessionUseCase,
    this._profileViewModel,
    this._getProfileDataUseCase,
  ) : super(const SmartCoachState()) {
    on<LoadSmartCoachHistoryEvent>(_onLoadHistory);
    on<StartNewChatSessionEvent>(_onStartNewChat);
    on<SelectChatSessionEvent>(_onSelectSession);
    on<SendSmartCoachMessageEvent>(_onSendMessage);
    on<ClearAttachedImageEvent>(_onClearImage);
    on<AttachImageEvent>(_onAttachImage);
  }

  void _onAttachImage(
    AttachImageEvent event,
    Emitter<SmartCoachState> emit,
  ) {
    emit(state.copyWith(attachedImagePath: event.imagePath));
  }

  void _onLoadHistory(
    LoadSmartCoachHistoryEvent event,
    Emitter<SmartCoachState> emit,
  ) async {
    final result = await _getHistoryUseCase.execute();
    if (result is SuccessBaseResponse<List<ChatSessionEntity>>) {
      final sessions = result.data;
      emit(state.copyWith(sessions: sessions));
    }
  }

  void _onStartNewChat(
    StartNewChatSessionEvent event,
    Emitter<SmartCoachState> emit,
  ) {
    final newSessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final welcomeMsg = ChatMessageEntity(
      id: 'welcome_$newSessionId',
      content: AppStrings.howCanIAssistYouToday,
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    );

    emit(state.copyWith(
      viewMode: SmartCoachViewMode.activeChat,
      activeSessionId: newSessionId,
      messages: [welcomeMsg],
      attachedImagePath: null,
    ));
  }

  void _onSelectSession(
    SelectChatSessionEvent event,
    Emitter<SmartCoachState> emit,
  ) {
    final session = state.sessions.firstWhere(
      (s) => s.sessionId == event.sessionId,
      orElse: () => ChatSessionEntity(
        sessionId: event.sessionId,
        title: '',
        lastUpdated: DateTime.now(),
        messages: [],
      ),
    );

    emit(state.copyWith(
      viewMode: SmartCoachViewMode.activeChat,
      activeSessionId: session.sessionId,
      messages: session.messages,
      attachedImagePath: null,
    ));
  }

  void _onClearImage(
    ClearAttachedImageEvent event,
    Emitter<SmartCoachState> emit,
  ) {
    emit(state.copyWith(attachedImagePath: null));
  }

  void _onSendMessage(
    SendSmartCoachMessageEvent event,
    Emitter<SmartCoachState> emit,
  ) async {
    if (event.content.trim().isEmpty && event.imagePath == null) return;

    final sessionId = state.activeSessionId.isEmpty
        ? DateTime.now().millisecondsSinceEpoch.toString()
        : state.activeSessionId;

    final userMsg = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: event.content.trim(),
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      imagePath: event.imagePath,
    );

    final updatedMessages = List<ChatMessageEntity>.from(state.messages)
      ..add(userMsg);

    emit(state.copyWith(
      viewMode: SmartCoachViewMode.activeChat,
      activeSessionId: sessionId,
      messages: updatedMessages,
      isLoadingAi: true,
      attachedImagePath: null,
    ));

    ProfileEntity? profile = _profileViewModel.state.getProfileState.data;
    if (profile == null) {
      try {
        final profileRes = await _getProfileDataUseCase.getProfileData();
        if (profileRes is SuccessBaseResponse<ProfileEntity>) {
          profile = profileRes.data;
        }
      } catch (_) {}
    }

    final response = await _sendMessageUseCase.execute(
      sessionId: sessionId,
      messageContent: event.content,
      profile: profile,
      languageCode: event.languageCode,
      imagePath: event.imagePath,
      history: updatedMessages,
    );

    await _handleAiResponse(response, sessionId, updatedMessages, emit);
  }

  Future<void> _handleAiResponse(
    BaseResponse<ChatMessageEntity> response,
    String sessionId,
    List<ChatMessageEntity> currentMessages,
    Emitter<SmartCoachState> emit,
  ) async {
    if (response is SuccessBaseResponse<ChatMessageEntity>) {
      final aiMessage = response.data;
      final finalMessages = List<ChatMessageEntity>.from(currentMessages)
        ..add(aiMessage);

      final userMessage = currentMessages.firstWhere(
        (m) => m.sender == MessageSender.user,
        orElse: () => currentMessages.first,
      );

      final rawTitle = userMessage.content.trim();
      final sessionTitle = rawTitle.length > 25
          ? '${rawTitle.substring(0, 25)}...'
          : rawTitle;

      final session = ChatSessionEntity(
        sessionId: sessionId,
        title: sessionTitle,
        lastUpdated: DateTime.now(),
        messages: finalMessages,
      );

      await _saveSessionUseCase.execute(session);
      final historyRes = await _getHistoryUseCase.execute();
      final sessions =
          historyRes is SuccessBaseResponse<List<ChatSessionEntity>>
              ? historyRes.data
              : state.sessions;

      emit(state.copyWith(
        messages: finalMessages,
        sessions: sessions,
        isLoadingAi: false,
      ));
    } else if (response is ErrorBaseResponse<ChatMessageEntity>) {
      final errorMsg = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response.errorMessage,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );

      final finalMessages = List<ChatMessageEntity>.from(currentMessages)
        ..add(errorMsg);

      emit(state.copyWith(
        messages: finalMessages,
        isLoadingAi: false,
      ));
    }
  }
}
