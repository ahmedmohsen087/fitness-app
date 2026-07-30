import 'package:fitness_app/core/reusable_widgets/custom_filter_tab_bar.dart';
import 'package:fitness_app/features/fitness/domain/entities/muscle_entity.dart';

abstract class DummyWorkoutsData {
  static const List<CustomFilterTabBarItem> skeletonFilterTabs = [
    CustomFilterTabBarItem(id: '1', title: 'Full Body'),
    CustomFilterTabBarItem(id: '2', title: 'Chest'),
    CustomFilterTabBarItem(id: '3', title: 'Back'),
  ];

  static const List<MuscleEntity> skeletonWorkouts = [
    MuscleEntity(id: 's1', name: 'Loading', image: ''),
    MuscleEntity(id: 's2', name: 'Loading', image: ''),
    MuscleEntity(id: 's3', name: 'Loading', image: ''),
    MuscleEntity(id: 's4', name: 'Loading', image: ''),
  ];
}
