import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class CategoryModel extends StatelessWidget {
  final String image;
  final String title;

  const CategoryModel({required this.image, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image),
        Text(
          title,
          style: TextStyles.bodyRegular12.copyWith(color: AppColors.lightGray),
        ),
      ],
    );
  }
}
