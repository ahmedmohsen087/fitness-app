import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../view_models/home_events.dart';
import '../view_models/home_states.dart';
import '../view_models/home_view_models.dart';

class MusclesGroupList extends StatelessWidget {
  const MusclesGroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final viewModel = context.read<HomeViewModel>();

        final muscles = state.musclesGroupState.data?.musclesGroup ?? [];

        final isLoading = state.musclesGroupState.isLoading;

        return SizedBox(
          height: 36,
          child: Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: isLoading ? 5 : muscles.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                if (isLoading) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Loading",
                      style: TextStyles.bodyRegular12.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                final muscle = muscles[index];

                final isSelected = muscle.id == viewModel.selectedMuscleGroupId;

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    viewModel.doEvent(GetMusclesGroupByIdEvent(muscle.id));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.orange : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.orange),
                    ),
                    child: Text(
                      muscle.name,
                      style: TextStyles.bodyRegular12.copyWith(
                        color: isSelected ? AppColors.white : AppColors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
