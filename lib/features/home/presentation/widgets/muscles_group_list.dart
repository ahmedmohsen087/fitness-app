import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class MusclesGroupList extends StatelessWidget {
  const MusclesGroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) =>
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Text('Full Body ',
              style: TextStyles.bodyRegular12.copyWith(
                color: AppColors.white,
                fontWeight:FontWeight.bold
              ),
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(width: 10,),
          itemCount: 5),
    );
  }
}
