import 'package:fitness_app/core/reusable_widgets/custom_filter_tab_bar.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_events.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:fitness_app/features/section_app/domain/entities/dummy_workouts_data.dart';
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
        final groups = state.muscleGroupsState.data ?? [];
        final isLoading = state.muscleGroupsState.isLoading;

        if (isLoading && groups.isEmpty) {
          return _buildSkeletonTabs();
        }

        return _buildFilterTabBar(context, groups);
      },
    );
  }

  Widget _buildSkeletonTabs() {
    return SizedBox(
      height: 40,
      child: Skeletonizer(
        enabled: true,
        child: CustomFilterTabBar(
          items: DummyWorkoutsData.skeletonFilterTabs,
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
      ),
    );
  }

  Widget _buildFilterTabBar(BuildContext context, List groups) {
    final viewModel = context.read<FitnessViewModel>();
    final items = [
      CustomFilterTabBarItem(id: 'full_body', title: AppStrings.fullBody),
      ...groups.map((g) => CustomFilterTabBarItem(id: g.id, title: g.name)),
    ];

    final selectedIndex = _getSelectedIndex(items);

    return CustomFilterTabBar(
      items: items,
      selectedIndex: selectedIndex,
      onTabSelected: (index) => _onTabSelected(viewModel, items, index),
    );
  }

  int _getSelectedIndex(List<CustomFilterTabBarItem> items) {
    if (selectedMuscleGroupId == null) return 0;
    final index = items.indexWhere((item) => item.id == selectedMuscleGroupId);
    return index >= 0 ? index : 0;
  }

  void _onTabSelected(
    FitnessViewModel viewModel,
    List<CustomFilterTabBarItem> items,
    int index,
  ) {
    final selectedItem = items[index];
    if (selectedItem.id == 'full_body') {
      onFullBodyTap();
    } else {
      onGroupTap(selectedItem.id);
      viewModel.doEvent(SelectMuscleGroupEvent(selectedItem.id));
    }
  }
}
