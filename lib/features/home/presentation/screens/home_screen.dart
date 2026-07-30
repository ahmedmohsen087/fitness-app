import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/reusable_widgets/custom_section_header.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_events.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_events.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_view_models.dart';
import 'package:fitness_app/features/home/presentation/widgets/category_item.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_events.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_view_model.dart';
import 'package:fitness_app/features/section_app/view_model/section_tab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/muscles_group_list.dart';
import '../widgets/popular_training_widget.dart';
import '../widgets/recommendation_for_you_widget.dart';
import '../widgets/recommendation_to_day.dart';
import '../widgets/upcoming_workouts_widget.dart';
import 'home_profile_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeViewModel>(
          create: (_) => getIt<HomeViewModel>()..doEvent(LoadHomeDataEvent()),
        ),
        BlocProvider<FitnessViewModel>(
          create: (_) =>
              getIt<FitnessViewModel>()..doEvent(LoadHomeFitnessDataEvent()),
        ),
        BlocProvider<GetProfileViewModel>(
          create: (_) =>
              getIt<GetProfileViewModel>()
                ..doEvent(const RefreshProfileEvent()),
        ),
      ],
      child: AppBackgroundScaffold(
        imagePath: Assets.mainBackground,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<GetProfileViewModel, GetProfileState>(
                  builder: (context, state) {
                    final profile = state.getProfileState.data;
                    final name = profile != null
                        ? "${profile.firstName} ${profile.lastName}".trim()
                        : null;
                    final image = profile?.photo;

                    return HomeProfileInfo(
                      name: name,
                      image: image,
                      onProfileTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutsName.profileScreen,
                        );
                      },
                    );
                  },
                ),
                Text(
                  AppStrings.category,
                  style: TextStyles.labelTextFieldStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const CategoryItem(),
                CustomSectionHeader(title: AppStrings.recommendationToDay),
                const RecommendationToDay(),
                CustomSectionHeader(
                  title: AppStrings.upcomingWorkouts,
                  onSeeAllTap: () =>
                      context.read<SectionTabCubit>().changeTab(AppTab.workout),
                ),
                const MusclesGroupList(),
                const UpcomingWorkoutsWidget(),
                CustomSectionHeader(
                  title: AppStrings.recommendationForYou,
                  onSeeAllTap: () =>
                      Navigator.pushNamed(context, AppRoutsName.food),
                ),
                const RecommendationForYouWidget(),
                CustomSectionHeader(title: AppStrings.popularTraining),
                const PopularTrainingWidget(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
