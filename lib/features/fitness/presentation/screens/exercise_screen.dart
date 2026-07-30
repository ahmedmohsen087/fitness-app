import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/reusable_widgets/app_video_dialog.dart';
import 'package:fitness_app/core/reusable_widgets/custom_filter_tab_bar.dart';
import 'package:fitness_app/core/reusable_widgets/custom_network_image.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_events.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_state.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExerciseScreenArgs {
  final String primeMoverMuscleId;
  final String muscleName;
  final String image;
  final String? initialLevelId;

  const ExerciseScreenArgs({
    required this.primeMoverMuscleId,
    required this.muscleName,
    required this.image,
    this.initialLevelId,
  });
}

class ExerciseScreen extends StatelessWidget {
  final ExerciseScreenArgs args;

  const ExerciseScreen({super.key, required this.args});

  String _getYoutubeThumbnail(String videoUrl) {
    final videoId = YoutubeVideoIdParser.parse(videoUrl);
    if (videoId != null && videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    }
    return 'https://iili.io/33p7bcv.png';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FitnessViewModel>(
      create: (_) {
        final vm = getIt<FitnessViewModel>();
        vm.doEvent(
          LoadExerciseDetailsEvent(
            args.primeMoverMuscleId,
            args.initialLevelId,
          ),
        );
        return vm;
      },
      child: AppBackgroundScaffold(
        imagePath: Assets.mainBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.lightBlack,
                      ),
                      child: ClipRRect(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CustomNetworkImage(
                              imageUrl: args.image.isNotEmpty
                                  ? args.image
                                  : 'https://iili.io/33p7bcv.png',
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.4),
                                    AppColors.black.withValues(alpha: 0.9),
                                  ],
                                  stops: const [0.0, 1.0],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 24,
                      child: Column(
                        spacing: 8,
                        children: [
                          Text(
                            args.muscleName.isNotEmpty
                                ? "${args.muscleName} Exercise"
                                : "Exercise",
                            textAlign: TextAlign.center,
                            style: TextStyles.bodyRegular24.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocBuilder<FitnessViewModel, FitnessState>(
                    builder: (context, state) {
                      final levels = state.difficultyLevelsState.data ?? [];
                      final isLoading = state.difficultyLevelsState.isLoading;

                      if (isLoading && levels.isEmpty) {
                        return const SizedBox(
                          height: 40,
                          child: Skeletonizer(
                            enabled: true,
                            child: CustomFilterTabBar(
                              items: [
                                CustomFilterTabBarItem(
                                  id: '1',
                                  title: 'Beginner',
                                ),
                                CustomFilterTabBarItem(
                                  id: '2',
                                  title: 'Intermediate',
                                ),
                                CustomFilterTabBarItem(
                                  id: '3',
                                  title: 'Advanced',
                                ),
                              ],
                              selectedIndex: 0,
                              onTabSelected: _dummyOnTabSelected,
                            ),
                          ),
                        );
                      }

                      final items = levels
                          .map(
                            (l) =>
                                CustomFilterTabBarItem(id: l.id, title: l.name),
                          )
                          .toList();

                      final activeLevelId = state.selectedLevelId;

                      final selectedIndex = activeLevelId == null
                          ? 0
                          : items
                                .indexWhere((item) => item.id == activeLevelId)
                                .clamp(0, items.isEmpty ? 0 : items.length - 1);

                      return CustomFilterTabBar(
                        padding: EdgeInsets.zero,
                        items: items,
                        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
                        onTabSelected: (index) {
                          final level = levels[index];
                          context.read<FitnessViewModel>().doEvent(
                            SelectDifficultyLevelEvent(
                              primeMoverMuscleId: args.primeMoverMuscleId,
                              difficultyLevelId: level.id,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocBuilder<FitnessViewModel, FitnessState>(
                    builder: (context, state) {
                      final isLoading =
                          state.exercisesByDifficultyState.isLoading;
                      final exercises =
                          state.exercisesByDifficultyState.data ?? [];

                      if (!isLoading && exercises.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              AppStrings.noWorkoutsFound,
                              style: TextStyles.bodyRegular16.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        );
                      }

                      return Skeletonizer(
                        enabled: isLoading && exercises.isEmpty,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: isLoading && exercises.isEmpty
                              ? 4
                              : exercises.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (isLoading && exercises.isEmpty) {
                              return Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlack,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              );
                            }

                            final exercise = exercises[index];
                            final thumbUrl = _getYoutubeThumbnail(
                              exercise.videoUrl,
                            );

                            final subtitleInfo =
                                exercise.primaryEquipment.isNotEmpty
                                ? exercise.primaryEquipment
                                : exercise.targetMuscleGroup;

                            return GestureDetector(
                              onTap: () {
                                AppVideoDialog.show(
                                  context,
                                  youtubeUrl: exercise.videoUrl,
                                  title: exercise.exercise,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: AppColors.lightBlack,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        width: 64,
                                        height: 64,
                                        child: CustomNetworkImage(
                                          imageUrl: thumbUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 4,
                                        children: [
                                          Text(
                                            exercise.exercise,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles.bodyRegular16
                                                .copyWith(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          if (subtitleInfo.isNotEmpty)
                                            Text(
                                              subtitleInfo,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyles.bodyRegular12
                                                  .copyWith(
                                                    color: AppColors.white
                                                        .withValues(alpha: 0.7),
                                                  ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: const BoxDecoration(
                                        color: AppColors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: AppColors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _dummyOnTabSelected(int index) {}
}
