import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/chat_session_entity.dart';

class SmartCoachHistoryDrawerWidget extends StatelessWidget {
  final List<ChatSessionEntity> sessions;
  final String activeSessionId;
  final Function(String sessionId) onSessionSelected;
  final VoidCallback onNewChatTap;

  const SmartCoachHistoryDrawerWidget({
    super.key,
    required this.sessions,
    required this.activeSessionId,
    required this.onSessionSelected,
    required this.onNewChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.lightBlack,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const Divider(color: AppColors.lightGray),
            _buildNewChatButton(),
            Expanded(child: _buildSessionList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        AppStrings.previousConversations,
        style: TextStyles.bodyRegular20.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildNewChatButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 44),
        ),
        onPressed: onNewChatTap,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text(
          AppStrings.newChat,
          style: TextStyles.buttonTextStyle,
        ),
      ),
    );
  }

  Widget _buildSessionList() {
    return ListView.builder(
      itemCount: sessions.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final session = sessions[index];
        final isSelected = session.sessionId == activeSessionId;

        return ListTile(
          leading: Icon(
            Icons.chevron_left,
            color: isSelected ? AppColors.orange : AppColors.lightGray,
          ),
          title: Text(
            session.title.isNotEmpty ? session.title : 'Chat ${index + 1}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.bodyRegular14.copyWith(
              color: isSelected ? AppColors.orange : AppColors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () => onSessionSelected(session.sessionId),
        );
      },
    );
  }
}
