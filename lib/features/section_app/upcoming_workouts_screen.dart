import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/section_app/widgets/workouts_filter_tabs.dart';
import 'package:fitness_app/features/section_app/widgets/workouts_grid.dart';
import 'package:flutter/material.dart';

class UpcomingWorkoutsScreen extends StatefulWidget {
  const UpcomingWorkoutsScreen({super.key});

  @override
  State<UpcomingWorkoutsScreen> createState() => _UpcomingWorkoutsScreenState();
}

class _UpcomingWorkoutsScreenState extends State<UpcomingWorkoutsScreen> {
  String? _selectedMuscleGroupId;

  void _onFullBodySelected() {
    if (_selectedMuscleGroupId == null) return;
    setState(() => _selectedMuscleGroupId = null);
  }

  void _onMuscleGroupSelected(String id) {
    setState(() => _selectedMuscleGroupId = id);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundScaffold(
      imagePath: Assets.mainBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Center(
              child: Text(
                AppStrings.workouts,
                style: TextStyles.bodyRegular24,
              ),
            ),
            WorkoutsFilterTabs(
              selectedMuscleGroupId: _selectedMuscleGroupId,
              onFullBodyTap: _onFullBodySelected,
              onGroupTap: _onMuscleGroupSelected,
            ),
            Expanded(
              child: WorkoutsGrid(
                selectedMuscleGroupId: _selectedMuscleGroupId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
