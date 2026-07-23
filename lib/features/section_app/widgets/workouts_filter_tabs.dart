import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_events.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_states.dart';
import 'package:fitness_app/features/home/presentation/view_models/home_view_models.dart';
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
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final viewModel = context.read<HomeViewModel>();
        final groups = state.musclesGroupState.data?.musclesGroup ?? [];
        final isLoading = state.musclesGroupState.isLoading;
        final itemCount = (isLoading ? 5 : groups.length) + 1;

        return SizedBox(
          height: 36,
          child: Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              separatorBuilder: (_, _) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _FilterChip(
                    label: AppStrings.fullBody,
                    selected: selectedMuscleGroupId == null,
                    onTap: onFullBodyTap,
                  );
                }

                if (isLoading) {
                  return const _FilterChip(label: 'Group', selected: false);
                }

                final group = groups[index - 1];
                return _FilterChip(
                  label: group.name,
                  selected: group.id == selectedMuscleGroupId,
                  onTap: () {
                    onGroupTap(group.id);
                    viewModel.doEvent(GetMusclesGroupByIdEvent(group.id));
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _FilterChip({required this.label, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyles.bodyRegular14.copyWith(
            color: AppColors.white,
            fontWeight: selected ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
