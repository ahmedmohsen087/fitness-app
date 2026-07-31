import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/reusable_widgets/custom_network_image.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeProfileInfo extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const HomeProfileInfo({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    context.locale;

    return BlocBuilder<GetProfileViewModel, GetProfileState>(
      buildWhen: (previous, current) =>
          previous.getProfileState.data != current.getProfileState.data,
      builder: (context, state) {
        final user = state.getProfileState.data;
        final name = user != null ? user.firstName : '';
        final image = user?.photo;

        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? '${AppStrings.hi} $name,' : '${AppStrings.hi},',
                  style: TextStyles.bodyRegular16,
                ),
                Text(
                  AppStrings.letsStartYourDay,
                  style: TextStyles.bodyMedium18.copyWith(color: AppColors.white),
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.placeHolder,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: CustomNetworkImage(
                    imageUrl: (image != null && image.isNotEmpty)
                        ? image
                        : Assets.defaultExerciseImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
