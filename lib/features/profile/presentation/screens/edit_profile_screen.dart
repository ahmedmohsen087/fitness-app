import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di/di.dart';
import '../../../../core/reusable_widgets/app_background_scaffold.dart';
import '../../../../core/reusable_widgets/app_toast.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../../domain/entities/profile_response_entity.dart';
import '../view_models/edit_profile_view_models/edit_profile_events.dart';
import '../view_models/edit_profile_view_models/edit_profile_states.dart';
import '../view_models/edit_profile_view_models/edit_profile_view_model.dart';
import '../widgets/edit_profile_form.dart';
import '../widgets/edit_profile_selection_pages.dart';

class EditProfileScreen extends StatelessWidget {
  final ProfileResponseEntity profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<EditProfileViewModel>()
            ..doEvent(InitializeEditProfileEvent(profile: profile)),
      child: _EditProfileView(profile: profile),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  final ProfileResponseEntity profile;

  const _EditProfileView({required this.profile});

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.profile.firstName)
      ..addListener(_refreshName);
    _lastNameController = TextEditingController(text: widget.profile.lastName)
      ..addListener(_refreshName);
    _emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _refreshName() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileViewModel, EditProfileState>(
      listenWhen: (previous, current) =>
          previous.submitState != current.submitState ||
          previous.uploadPhotoState != current.uploadPhotoState,
      listener: _listenForResult,
      builder: (context, state) {
        return PopScope(
          canPop: state.page == EditProfilePage.details,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _showPage(EditProfilePage.details);
          },
          child: state.page == EditProfilePage.details
              ? _buildDetails(state)
              : EditProfileSelectionPage(page: state.page),
        );
      },
    );
  }

  Widget _buildDetails(EditProfileState state) {
    final profile = state.profile ?? widget.profile;
    final name =
        '${_firstNameController.text.trim()} '
                '${_lastNameController.text.trim()}'
            .trim();

    return AppBackgroundScaffold(
      imagePath: Assets.mainBackground,
      child: Column(
        children: [
          _EditProfileHeader(onBack: () => Navigator.pop(context)),
          Expanded(
            child: EditProfileForm(
              formKey: _formKey,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              emailController: _emailController,
              userName: name,
              imageUrl: profile.photo,
              localPhotoPath: state.localPhotoPath,
              weight: state.weight ?? profile.weight,
              goal: state.goal,
              activityLevel: state.activityLevel,
              isSubmitting: state.submitState.isLoading,
              isUploadingPhoto: state.uploadPhotoState.isLoading,
              onPickPhoto: () {
                context.read<EditProfileViewModel>().doEvent(
                  const SelectEditProfilePhotoEvent(),
                );
              },
              onEditField: (field) {
                _showPage(switch (field) {
                  EditProfileField.weight => EditProfilePage.weight,
                  EditProfileField.goal => EditProfilePage.goal,
                  EditProfileField.activity => EditProfilePage.activity,
                });
              },
              onSubmit: _submit,
            ),
          ),
        ],
      ),
    );
  }

  void _listenForResult(BuildContext context, EditProfileState state) {
    final submitError = state.submitState.msg;
    if (!state.submitState.isLoading && submitError != null) {
      AppToast.error(context, submitError);
    } else if (state.submitState.data != null) {
      AppToast.success(context, AppStrings.profileUpdatedSuccessfully);
      Navigator.pop(context, state.submitState.data);
      return;
    }

    final uploadError = state.uploadPhotoState.msg;
    if (!state.uploadPhotoState.isLoading && uploadError != null) {
      AppToast.error(context, uploadError);
    } else if (state.uploadPhotoState.data != null) {
      AppToast.success(context, AppStrings.profilePhotoUpdatedSuccessfully);
    }
  }

  void _showPage(EditProfilePage page) {
    context.read<EditProfileViewModel>().doEvent(
      ChangeEditProfilePageEvent(page: page),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<EditProfileViewModel>().doEvent(
      SubmitEditProfileEvent(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
      ),
    );
  }
}

class _EditProfileHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _EditProfileHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Text(AppStrings.editProfile, style: TextStyles.authTitle),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: Semantics(
                button: true,
                label: AppStrings.back,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onBack,
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.orange,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
