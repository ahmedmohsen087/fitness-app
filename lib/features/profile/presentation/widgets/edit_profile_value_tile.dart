import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';

class EditProfileValueTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const EditProfileValueTile({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title ${AppStrings.tapToEdit}',
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$title ('),
                  TextSpan(
                    text: AppStrings.tapToEdit,
                    style: TextStyles.authButton.copyWith(
                      color: AppColors.orange,
                    ),
                  ),
                  const TextSpan(text: ')'),
                ],
              ),
              style: TextStyles.authButton,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: AlignmentDirectional.centerStart,
              decoration: BoxDecoration(
                color: AppColors.lightGray.withValues(alpha: 0.2),
                border: Border.all(color: AppColors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(value, style: TextStyles.authOption),
            ),
          ],
        ),
      ),
    );
  }
}
