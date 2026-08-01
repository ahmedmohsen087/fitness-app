import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/smart_coach_enums.dart';
import '../view_models/smart_coach_events.dart';
import '../view_models/smart_coach_states.dart';
import '../view_models/smart_coach_view_model.dart';
import '../widgets/smart_coach_active_widget.dart';
import '../widgets/smart_coach_history_drawer_widget.dart';
import '../widgets/smart_coach_welcome_widget.dart';

class SmartCoachScreen extends StatelessWidget {
  const SmartCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SmartCoachViewModel>(
      create: (_) => getIt<SmartCoachViewModel>()
        ..add(const LoadSmartCoachHistoryEvent()),
      child: const _SmartCoachScreenContent(),
    );
  }
}

class _SmartCoachScreenContent extends StatelessWidget {
  const _SmartCoachScreenContent();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocListener<SmartCoachViewModel, SmartCoachState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          current.errorMessage != previous.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      child: BlocBuilder<SmartCoachViewModel, SmartCoachState>(
        builder: (context, state) {
          final profile =
              context.watch<GetProfileViewModel>().state.getProfileState.data;
          final firstName = profile?.firstName ?? '';

          return AppBackgroundScaffold(
            imagePath: Assets.chatBackground,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.transparent,
              endDrawer: SmartCoachHistoryDrawerWidget(
                sessions: state.sessions,
                activeSessionId: state.activeSessionId,
                onSessionSelected: (sessionId) {
                  Navigator.pop(context);
                  context
                      .read<SmartCoachViewModel>()
                      .add(SelectChatSessionEvent(sessionId));
                },
                onNewChatTap: () {
                  Navigator.pop(context);
                  context
                      .read<SmartCoachViewModel>()
                      .add(const StartNewChatSessionEvent());
                },
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(
                        context, scaffoldKey, state.viewMode, firstName),
                    Expanded(child: _buildBody(context, state, profile?.photo)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
    SmartCoachViewMode viewMode,
    String firstName,
  ) {
    final titleText = viewMode == SmartCoachViewMode.welcome
        ? '${AppStrings.hi} ${firstName.isNotEmpty ? firstName : "User"} ,\n${AppStrings.iAmYourSmartCoach}'
        : AppStrings.smartCoach;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Text(
              titleText,
              textAlign: TextAlign.center,
              style: TextStyles.bodyRegular16.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
            icon: const Icon(Icons.menu, color: AppColors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SmartCoachState state,
    String? userPhotoUrl,
  ) {
    if (state.viewMode == SmartCoachViewMode.welcome) {
      return SmartCoachWelcomeWidget(
        onGetStartedTap: () => context.read<SmartCoachViewModel>().add(
          const StartNewChatSessionEvent(),
        ),
      );
    }

    return SmartCoachActiveWidget(
      messages: state.messages,
      isLoadingAi: state.isLoadingAi,
      userPhotoUrl: userPhotoUrl,
      attachedImagePath: state.attachedImagePath,
      onSendMessage: (text, imagePath) {
        String langCode = 'en';
        try {
          langCode = context.locale.languageCode;
        } catch (_) {}
        context.read<SmartCoachViewModel>().add(
          SendSmartCoachMessageEvent(
            content: text,
            imagePath: imagePath,
            languageCode: langCode,
          ),
        );
      },
      onImageAttached: (path) {
        context.read<SmartCoachViewModel>().add(AttachImageEvent(path));
      },
      onClearImage: () {
        context.read<SmartCoachViewModel>().add(const ClearAttachedImageEvent());
      },
    );
  }
}
