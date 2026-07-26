import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final VoidCallback onBackPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_circle_left,
                color: AppColors.orange,
                size: 32,
              ),
              onPressed: onBackPressed,
            ),
            Text(
              AppStrings.profile,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 48),
          ],
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
