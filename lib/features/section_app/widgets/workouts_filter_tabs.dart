import 'package:fitness_app/core/reusable_widgets/custom_filter_tab_bar.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_events.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkoutsFilterTabs extends StatelessWidget {
  final String? selectedMuscleGroupId;
  final VoidCallback onFullBodyTap;
  final ValueChanged<String> onGroupTap;

  const WorkoutsFilterTabs({
    super.key,
    required this.selectedMuscleGroupId,
    required this.onFullBodyTap,
    required this.onGroupTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessViewModel, FitnessState>(
      builder: (context, state) {
        final viewModel = context.read<FitnessViewModel>();
        final groups = state.muscleGroupsState.data ?? [];
        final isLoading = state.muscleGroupsState.isLoading;

        if (isLoading && groups.isEmpty) {
          return const SizedBox(
            height: 40,
            child: Skeletonizer(
              enabled: true,
              child: CustomFilterTabBar(
                items: [
                  CustomFilterTabBarItem(id: '1', title: 'Full Body'),
                  CustomFilterTabBarItem(id: '2', title: 'Chest'),
                  CustomFilterTabBarItem(id: '3', title: 'Back'),
                ],
                selectedIndex: 0,
                onTabSelected: _dummyTabSelected,
              ),
            ),
          );
        }

        final items = [
          CustomFilterTabBarItem(id: 'full_body', title: AppStrings.fullBody),
          ...groups.map((g) => CustomFilterTabBarItem(id: g.id, title: g.name)),
        ];

        final selectedIndex = selectedMuscleGroupId == null
            ? 0
            : items
                  .indexWhere((item) => item.id == selectedMuscleGroupId)
                  .clamp(0, items.length - 1);

        return CustomFilterTabBar(
          padding: EdgeInsets.zero,
          items: items,
          selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
          onTabSelected: (index) {
            if (index == 0) {
              onFullBodyTap();
            } else {
              final group = groups[index - 1];
              onGroupTap(group.id);
              viewModel.doEvent(SelectMuscleGroupEvent(group.id));
            }
          },
        );
      },
    );
  }

  static void _dummyTabSelected(int index) {}
}
