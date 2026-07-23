import 'package:fitness_app/core/reusable_widgets/app_bottom_nav_bar.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/home/presentation/screens/home_screen.dart';
import 'package:fitness_app/features/section_app/chat_screen.dart';
import 'package:fitness_app/features/section_app/profile_screen.dart';
import 'package:fitness_app/features/section_app/workouts_screen.dart';
import 'package:flutter/material.dart';

enum AppTab { home, chat, workout, profile }

class SectionApp extends StatefulWidget {
  final int initialTabIndex;

  const SectionApp({super.key, this.initialTabIndex = 0});

  @override
  State<SectionApp> createState() => _SectionAppState();
}

class _SectionAppState extends State<SectionApp> {
  late AppTab currentTab;

  @override
  void initState() {
    super.initState();
    final safeIndex =
        widget.initialTabIndex >= 0 &&
            widget.initialTabIndex < AppTab.values.length
        ? widget.initialTabIndex
        : 0;
    currentTab = AppTab.values[safeIndex];
  }

  final List<Widget> pages = const [
    HomeScreen(),
    ChatScreen(),
    WorkoutsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentTab.index, children: pages),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentTab.index,
        onTap: (index) => setState(() => currentTab = AppTab.values[index]),
        items: [
          AppBottomNavItem(icon: Assets.homeIcon, label: AppStrings.home),
          AppBottomNavItem(icon: Assets.chatIcon, label: AppStrings.chat),
          AppBottomNavItem(
            icon: Assets.workoutsIcon,
            label: AppStrings.workouts,
          ),
          AppBottomNavItem(icon: Assets.profileIcon, label: AppStrings.profile),
        ],
      ),
    );
  }
}
