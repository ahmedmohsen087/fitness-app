import 'package:fitness_app/config/base_response/base_response.dart';
import 'package:fitness_app/config/base_state/base_state.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
import 'package:fitness_app/features/profile/domain/use_cases/get_profile_data_usecase.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_events.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfileViewModel extends Cubit<GetProfileState> {
  final GetProfileDataUseCase _getProfileDataUseCase;

  GetProfileViewModel(this._getProfileDataUseCase)
    : super(const GetProfileState());

  void doEvent(GetProfileEvent event) {
    switch (event) {
      case RefreshProfileEvent():
        _getProfile();
        break;
    }
  }

  Future<void> _getProfile() async {
    emit(
      state.copyWith(
        getProfileState: BaseState<ProfileResponseEntity>.loading(),
      ),
    );

    final response = await _getProfileDataUseCase.getProfileData();

    switch (response) {
      case SuccessBaseResponse<ProfileResponseEntity>():
        emit(
          state.copyWith(
            getProfileState: BaseState<ProfileResponseEntity>.success(
              response.data,
            ),
          ),
        );
        break;

      case ErrorBaseResponse<ProfileResponseEntity>():
        emit(
          state.copyWith(
            getProfileState: BaseState<ProfileResponseEntity>.error(
              response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
