import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String imageUrl;
  final String userName;

  const ProfileHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            AppStrings.profile,
            style: TextStyles.bodyMedium18.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 24),
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.grey[800],
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          child: imageUrl.isEmpty
              ? const Icon(Icons.person, size: 55, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: TextStyles.bodyMedium18.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
