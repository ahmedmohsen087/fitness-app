import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/section_app/chat_screen.dart';
import 'package:fitness_app/features/section_app/home_screen.dart';
import 'package:fitness_app/features/section_app/profile_screen.dart';
import 'package:fitness_app/features/section_app/workouts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppTab { home, chat, workout, profile }

class SectionApp extends StatefulWidget {
  const SectionApp({super.key});

  @override
  State<SectionApp> createState() => _SectionAppState();
}

class _SectionAppState extends State<SectionApp> {
  AppTab currentTab = AppTab.home;

  final List<Widget> pages = const [
    HomeScreen(),
    ChatScreen(),
    WorkoutsScreen(),
    ProfileScreen(),
  ];

  BottomNavigationBarItem buildNavItem({
    required String asset,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        asset,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        asset,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(
          AppColors.orange,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentTab.index,
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightBlack,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: currentTab.index,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.orange,
              unselectedItemColor: Colors.white,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              onTap: (index) {
                setState(() {
                  currentTab = AppTab.values[index];
                });
              },
              items: [
                buildNavItem(
                  asset: Assets.homeIcon,
                  label: AppStrings.home,
                ),
                buildNavItem(
                  asset: Assets.chatIcon,
                  label: AppStrings.chat,
                ),
                buildNavItem(
                  asset: Assets.workoutsIcon,
                  label: AppStrings.workouts,
                ),
                buildNavItem(
                  asset: Assets.profileIcon,
                  label: AppStrings.profile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}