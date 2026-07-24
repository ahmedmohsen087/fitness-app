import 'package:fitness_app/features/home/presentation/widgets/category_item.dart';
import 'package:fitness_app/features/section_app/view_model/section_tab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../widgets/muscles_group_list.dart';
import '../widgets/recommendation_for_you_widget.dart';
import '../widgets/recommendation_to_day.dart';
import '../widgets/upcoming_workouts_widget.dart';
import 'home_profile_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Assets.homeBackGround, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeProfileInfo(),
                    Text(
                      AppStrings.category,
                      style: TextStyles.labelTextFieldStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CategoryItem(),
                    Row(
                      children: [
                        Text(
                          AppStrings.recommendationToDay,
                          style: TextStyles.labelTextFieldStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            AppStrings.seeAll,
                            style: TextStyles.textRegular12.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    RecommendationToDay(),
                    Row(
                      children: [
                        Text(
                          AppStrings.upcomingWorkouts,
                          style: TextStyles.labelTextFieldStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () => context
                              .read<SectionTabCubit>()
                              .changeTab(AppTab.workout),
                          child: Text(
                            AppStrings.seeAll,
                            style: TextStyles.textRegular12.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    MusclesGroupList(),
                    UpcomingWorkoutsWidget(),
                    Text(
                      AppStrings.recommendationForYou,
                      style: TextStyles.labelTextFieldStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RecommendationForYouWidget(),
                    Text(
                      AppStrings.popularTraining,
                      style: TextStyles.labelTextFieldStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
