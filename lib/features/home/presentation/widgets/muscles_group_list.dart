import 'package:fitness_app/core/reusable_widgets/custom_filter_tab_bar.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_events.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MusclesGroupList extends StatelessWidget {
  const MusclesGroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessViewModel, FitnessState>(
      builder: (context, state) {
        final viewModel = context.read<FitnessViewModel>();
        final groups = state.muscleGroupsState.data ?? [];
        final selectedId = state.selectedGroupId;

        final selectedIndex = groups.indexWhere((g) => g.id == selectedId);

        return CustomFilterTabBar(
          padding: EdgeInsets.zero,
          items: groups
              .map((g) => CustomFilterTabBarItem(id: g.id, title: g.name))
              .toList(),
          selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
          onTabSelected: (index) {
            if (index >= 0 && index < groups.length) {
              final group = groups[index];
              viewModel.doEvent(SelectMuscleGroupEvent(group.id));
            }
          },
        );
      },
    );
  }
}
