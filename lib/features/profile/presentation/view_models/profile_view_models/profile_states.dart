import 'package:equatable/equatable.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';

class GetProfileState extends Equatable {
  final BaseState<ProfileResponseEntity> getProfileState;

  const GetProfileState({this.getProfileState = const BaseState()});

  GetProfileState copyWith({
    BaseState<ProfileResponseEntity>? getProfileState,
  }) {
    return GetProfileState(
      getProfileState: getProfileState ?? this.getProfileState,
    );
  }

  @override
  List<Object?> get props => [getProfileState];
}
