import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/reusable_widgets/app_bottom_nav_bar.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/home/presentation/screens/home_screen.dart';
import 'package:fitness_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:fitness_app/features/section_app/upcoming_workouts_screen.dart';
import 'package:fitness_app/features/section_app/view_model/section_tab_cubit.dart';
import 'package:fitness_app/features/smart_coach/presentation/screens/smart_coach_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SectionApp extends StatelessWidget {
  const SectionApp({super.key});

  List<Widget> get _pages => const [
        HomeScreen(),
        SmartCoachScreen(),
        UpcomingWorkoutsScreen(),
        ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    context.locale;

    return BlocProvider(
      create: (_) => SectionTabCubit(),
      child: BlocBuilder<SectionTabCubit, AppTab>(
        builder: (context, currentTab) {
          return Scaffold(
            extendBody: true,
            body: IndexedStack(index: currentTab.index, children: _pages),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: currentTab.index,
              onTap: (index) => context.read<SectionTabCubit>().changeTab(
                AppTab.values[index],
              ),
              items: [
                AppBottomNavItem(icon: Assets.homeIcon, label: AppStrings.home),
                AppBottomNavItem(icon: Assets.chatIcon, label: AppStrings.chat),
                AppBottomNavItem(
                  icon: Assets.workoutsIcon,
                  label: AppStrings.workouts,
                ),
                AppBottomNavItem(
                  icon: Assets.profileIcon,
                  label: AppStrings.profile,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
