import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/reusable_widgets/app_video_dialog.dart';
import 'package:fitness_app/core/reusable_widgets/custom_filter_tab_bar.dart';
import 'package:fitness_app/core/reusable_widgets/custom_network_image.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/fitness/domain/entities/exercise_entity.dart';
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
    return YoutubeVideoIdParser.getThumbnail(
      videoUrl,
      fallback: Assets.defaultExerciseImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FitnessViewModel>(
      create: (_) => _createViewModel(),
      child: AppBackgroundScaffold(
        imagePath: Assets.mainBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                _buildHeader(context),
                _buildFilterSection(),
                _buildExercisesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FitnessViewModel _createViewModel() {
    final vm = getIt<FitnessViewModel>();
    vm.doEvent(
      LoadExerciseDetailsEvent(
        args.primeMoverMuscleId,
        args.initialLevelId,
      ),
    );
    return vm;
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        _buildHeaderBackground(),
        _buildBackButton(context),
        _buildHeaderTitle(),
      ],
    );
  }

  Widget _buildHeaderBackground() {
    final imageUrl =
        args.image.isNotEmpty ? args.image : Assets.defaultExerciseImage;

    return Container(
      height: 240,
      width: double.infinity,
      color: AppColors.lightBlack,
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
            _buildGradientOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
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
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned.directional(
      textDirection: Directionality.of(context),
      top: 16,
      start: 16,
      child: Semantics(
        button: true,
        label: AppStrings.back,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Navigator.maybePop(context),
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.orange,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTitle() {
    final title = args.muscleName.isNotEmpty
        ? "${args.muscleName} Exercise"
        : "Exercise";
    return Positioned(
      left: 20,
      right: 20,
      bottom: 24,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyles.bodyRegular24.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<FitnessViewModel, FitnessState>(
        buildWhen: (previous, current) =>
            previous.difficultyLevelsState != current.difficultyLevelsState ||
            previous.selectedLevelId != current.selectedLevelId,
        builder: (context, state) {
          final levels = state.difficultyLevelsState.data ?? [];
          final isLoading = state.difficultyLevelsState.isLoading;

          if (isLoading && levels.isEmpty) {
            return _buildSkeletonTabs();
          }

          final items = levels
              .map((l) => CustomFilterTabBarItem(id: l.id, title: l.name))
              .toList();

          final selectedIndex = _getSelectedIndex(items, state.selectedLevelId);

          return CustomFilterTabBar(
            items: items,
            selectedIndex: selectedIndex,
            onTabSelected: (index) {
              final selectedItem = items[index];
              context.read<FitnessViewModel>().doEvent(
                    SelectDifficultyLevelEvent(
                      difficultyLevelId: selectedItem.id,
                      primeMoverMuscleId: args.primeMoverMuscleId,
                    ),
                  );
            },
          );
        },
      ),
    );
  }

  Widget _buildSkeletonTabs() {
    return const SizedBox(
      height: 40,
      child: Skeletonizer(
        enabled: true,
        child: CustomFilterTabBar(
          items: [
            CustomFilterTabBarItem(id: '1', title: 'Beginner'),
            CustomFilterTabBarItem(id: '2', title: 'Intermediate'),
            CustomFilterTabBarItem(id: '3', title: 'Advanced'),
          ],
          selectedIndex: 0,
          onTabSelected: _dummyOnTabSelected,
        ),
      ),
    );
  }

  static void _dummyOnTabSelected(int _) {}

  int _getSelectedIndex(
    List<CustomFilterTabBarItem> items,
    String? selectedLevelId,
  ) {
    if (selectedLevelId == null) return 0;
    final index = items.indexWhere((item) => item.id == selectedLevelId);
    return index >= 0 ? index : 0;
  }

  Widget _buildExercisesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<FitnessViewModel, FitnessState>(
        buildWhen: (previous, current) =>
            previous.exercisesByDifficultyState !=
            current.exercisesByDifficultyState,
        builder: (context, state) {
          final exercises = state.exercisesByDifficultyState.data ?? [];
          final isLoading = state.exercisesByDifficultyState.isLoading;

          if (isLoading && exercises.isEmpty) {
            return _buildSkeletonExercises();
          }

          if (exercises.isEmpty && !isLoading) {
            return _buildEmptyState();
          }

          return _buildExercisesList(exercises);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          AppStrings.noWorkoutsFound,
          style: TextStyles.bodyRegular16.copyWith(
            color: AppColors.placeHolder,
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonExercises() {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => Container(
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.lightBlack,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildExercisesList(List<ExerciseEntity> exercises) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exercises.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _buildExerciseCard(context, exercises[index]),
    );
  }

  Widget _buildExerciseCard(BuildContext context, ExerciseEntity exercise) {
    final image = exercise.videoUrl.isNotEmpty
        ? _getYoutubeThumbnail(exercise.videoUrl)
        : (args.image.isNotEmpty ? args.image : Assets.defaultExerciseImage);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: GestureDetector(
          onTap: () => _playVideo(context, exercise),
          child: Container(
            width: 40,
            height: 40,
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
        ),
        title: Text(
          exercise.exercise,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.bodyRegular14.copyWith(color: AppColors.white),
        ),
        subtitle: Text(
          exercise.primaryEquipment,
          style: TextStyles.bodyRegular12.copyWith(color: AppColors.placeHolder),
        ),
        trailing: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomNetworkImage(
            imageUrl: image,
            width: 60,
            height: 45,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _playVideo(BuildContext context, ExerciseEntity exercise) {
    if (exercise.videoUrl.isEmpty) return;
    AppVideoDialog.show(
      context,
      youtubeUrl: exercise.videoUrl,
      title: exercise.exercise,
    );
  }
}
