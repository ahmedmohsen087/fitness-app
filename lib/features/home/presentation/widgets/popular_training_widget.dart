import 'package:fitness_app/core/reusable_widgets/custom_network_image.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/features/fitness/presentation/screens/exercise_screen.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PopularTrainingWidget extends StatelessWidget {
  const PopularTrainingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FitnessViewModel, FitnessState>(
      builder: (context, state) {
        final isLoading = state.popularTrainingState.isLoading;
        final items = state.popularTrainingState.data ?? [];

        return SizedBox(
          height: 160,
          child: Skeletonizer(
            enabled: isLoading && items.isEmpty,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: isLoading && items.isEmpty ? 3 : items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                if (isLoading && items.isEmpty) {
                  return Container(
                    width: 190,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlack,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  );
                }

                final item = items[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutsName.exercise,
                      arguments: ExerciseScreenArgs(
                        primeMoverMuscleId: item.primeMoverMuscleId,
                        muscleName: item.muscleName,
                        image: item.image,
                        initialLevelId: item.difficultyLevelId,
                      ),
                    );
                  },
                  child: Container(
                    width: 190,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.lightBlack,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CustomNetworkImage(
                            imageUrl: item.image,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.85),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.muscleName,
                                  style: TextStyles.bodyMedium18.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.fitness_center_rounded,
                                        size: 14,
                                        color: AppColors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${item.totalExercises} Exercises',
                                        style:
                                            TextStyles.bodyRegular12.copyWith(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.speed_rounded,
                                        size: 14,
                                        color: AppColors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.difficultyLevel,
                                        style:
                                            TextStyles.bodyRegular12.copyWith(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
