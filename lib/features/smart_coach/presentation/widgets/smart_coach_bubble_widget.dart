import 'dart:io';
import 'package:fitness_app/core/reusable_widgets/custom_network_image.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/smart_coach_enums.dart';
import 'smart_coach_action_card_widget.dart';

class SmartCoachBubbleWidget extends StatelessWidget {
  final ChatMessageEntity message;
  final String? userPhotoUrl;

  const SmartCoachBubbleWidget({
    super.key,
    required this.message,
    this.userPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildBotAvatar(),
          const SizedBox(width: 8),
          Flexible(child: _buildBubbleContent(context, isUser)),
          const SizedBox(width: 8),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return const CircleAvatar(
      radius: 18,
      backgroundColor: AppColors.lightBlack,
      backgroundImage: AssetImage(Assets.assetsAvatarsBotAvatar),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      radius: 18,
      backgroundColor: AppColors.orange,
      child: userPhotoUrl != null && userPhotoUrl!.isNotEmpty
          ? CustomNetworkImage(
              imageUrl: userPhotoUrl!,
              width: 36,
              height: 36,
              borderRadius: BorderRadius.circular(18),
            )
          : const Icon(Icons.person, color: AppColors.white, size: 20),
    );
  }

  Widget _buildBubbleContent(BuildContext context, bool isUser) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final sharpIsRight = isUser ? !isRtl : isRtl;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUser ? AppColors.orange : AppColors.lightBlack,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(sharpIsRight ? 16 : 0),
          topRight: Radius.circular(sharpIsRight ? 0 : 16),
          bottomLeft: const Radius.circular(16),
          bottomRight: const Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (message.imagePath != null && message.imagePath!.isNotEmpty)
            _buildImageAttachment(),
          if (message.content.isNotEmpty)
            Text(
              message.content,
              style: TextStyles.bodyRegular14.copyWith(color: AppColors.white),
            ),
          if (message.action != null)
            SmartCoachActionCardWidget(action: message.action!),
        ],
      ),
    );
  }

  Widget _buildImageAttachment() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(message.imagePath!),
          height: 180,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
