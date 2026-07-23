import 'package:bloc_test/bloc_test.dart';
import 'package:fitness_app/features/section_app/view_model/section_tab_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('initial state is AppTab.home', () {
    expect(SectionTabCubit().state, AppTab.home);
  });

  blocTest<SectionTabCubit, AppTab>(
    'emits [workout] when changeTab(workout) is called',
    build: () => SectionTabCubit(),
    act: (cubit) => cubit.changeTab(AppTab.workout),
    expect: () => [AppTab.workout],
  );

  blocTest<SectionTabCubit, AppTab>(
    'does not emit when changeTab is called with the same current tab',
    build: () => SectionTabCubit(),
    act: (cubit) => cubit.changeTab(AppTab.home),
    expect: () => [],
  );
}
