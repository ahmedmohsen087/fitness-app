import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_entity.dart';

class GetProfileState extends Equatable {
  final BaseState<ProfileEntity> getProfileState;

  const GetProfileState({this.getProfileState = const BaseState()});

  GetProfileState copyWith({
    BaseState<ProfileEntity>? getProfileState,
  }) {
    return GetProfileState(
      getProfileState: getProfileState ?? this.getProfileState,
    );
  }

  @override
  List<Object?> get props => [getProfileState];
}
