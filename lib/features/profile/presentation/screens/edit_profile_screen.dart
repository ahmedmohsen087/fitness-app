import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/reusable_widgets/app_background_scaffold.dart';
import '../../../../core/reusable_widgets/app_toast.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../../../../core/values/register_constants.dart';
import '../../domain/entities/profile_response_entity.dart';
import '../view_models/edit_profile_view_models/edit_profile_events.dart';
import '../view_models/edit_profile_view_models/edit_profile_states.dart';
import '../view_models/edit_profile_view_models/edit_profile_view_model.dart';
import '../widgets/edit_profile_form.dart';
import '../widgets/edit_profile_header.dart';
import '../widgets/edit_profile_selection_pages.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileResponseEntity profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  var _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.profile.firstName,
    );
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileViewModel, EditProfileState>(
      listenWhen: (previous, current) =>
          previous.submitState != current.submitState,
      listener: _listenForSubmit,
      child: BlocListener<EditProfileViewModel, EditProfileState>(
        listenWhen: (previous, current) =>
            previous.uploadPhotoState != current.uploadPhotoState,
        listener: _listenForPhotoUpload,
        child: _buildPageFlow(),
      ),
    );
  }

  Widget _buildPageFlow() {
    return PopScope(
      canPop: _pageIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDetails();
      },
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _pageIndex = index),
        children: _pages,
      ),
    );
  }

  List<Widget> get _pages => [
    _EditProfileDetails(
      profile: widget.profile,
      formKey: _formKey,
      firstNameController: _firstNameController,
      lastNameController: _lastNameController,
      emailController: _emailController,
      onBack: () => Navigator.pop(context),
      onPickPhoto: _pickPhoto,
      onEditField: _showSelection,
      onSubmit: _submit,
    ),
    for (final page in EditProfilePage.values)
      EditProfileSelectionPage(page: page, onClose: _showDetails),
  ];

  void _listenForSubmit(BuildContext context, EditProfileState state) {
    final error = state.submitState.msg;
    if (!state.submitState.isLoading && error != null) {
      AppToast.error(context, error);
      return;
    }
    final profile = state.submitState.data;
    if (profile == null) return;
    AppToast.success(context, AppStrings.profileUpdatedSuccessfully);
    Navigator.pop(context, profile);
  }

  void _listenForPhotoUpload(BuildContext context, EditProfileState state) {
    final error = state.uploadPhotoState.msg;
    if (!state.uploadPhotoState.isLoading && error != null) {
      AppToast.error(context, error);
      return;
    }
    if (state.uploadPhotoState.data != null) {
      AppToast.success(context, AppStrings.profilePhotoUpdatedSuccessfully);
    }
  }

  void _showSelection(EditProfileField field) {
    final index = switch (field) {
      EditProfileField.weight => 1,
      EditProfileField.goal => 2,
      EditProfileField.activity => 3,
    };
    _showPage(index);
  }

  void _showDetails() => _showPage(0);

  void _showPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _pickPhoto() {
    context.read<EditProfileViewModel>().doEvent(
      const SelectEditProfilePhotoEvent(),
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

typedef _EditProfileViewData = ({
  ProfileResponseEntity? profile,
  int? weight,
  FitnessGoal? goal,
  ActivityLevel? activityLevel,
  String? localPhotoPath,
  bool isSubmitting,
  bool isUploadingPhoto,
});

class _EditProfileDetails extends StatelessWidget {
  final ProfileResponseEntity profile;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final VoidCallback onBack;
  final VoidCallback onPickPhoto;
  final ValueChanged<EditProfileField> onEditField;
  final VoidCallback onSubmit;

  const _EditProfileDetails({
    required this.profile,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.onBack,
    required this.onPickPhoto,
    required this.onEditField,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      EditProfileViewModel,
      EditProfileState,
      _EditProfileViewData
    >(
      selector: _selectViewData,
      builder: (context, data) => AppBackgroundScaffold(
        imagePath: Assets.assetsImagesMainBackground,
        child: Column(
          children: [
            EditProfileHeader(onBack: onBack),
            Expanded(child: _buildForm(data)),
          ],
        ),
      ),
    );
  }

  _EditProfileViewData _selectViewData(EditProfileState state) => (
    profile: state.profile,
    weight: state.weight,
    goal: state.goal,
    activityLevel: state.activityLevel,
    localPhotoPath: state.localPhotoPath,
    isSubmitting: state.submitState.isLoading,
    isUploadingPhoto: state.uploadPhotoState.isLoading,
  );

  Widget _buildForm(_EditProfileViewData data) {
    final currentProfile = data.profile ?? profile;
    return ListenableBuilder(
      listenable: Listenable.merge([firstNameController, lastNameController]),
      builder: (context, _) => EditProfileForm(
        formKey: formKey,
        firstNameController: firstNameController,
        lastNameController: lastNameController,
        emailController: emailController,
        userName: _userName,
        imageUrl: currentProfile.photo,
        localPhotoPath: data.localPhotoPath,
        weight: data.weight ?? currentProfile.weight,
        goal: data.goal,
        activityLevel: data.activityLevel,
        isSubmitting: data.isSubmitting,
        isUploadingPhoto: data.isUploadingPhoto,
        onPickPhoto: onPickPhoto,
        onEditField: onEditField,
        onSubmit: onSubmit,
      ),
    );
  }

  String get _userName =>
      '${firstNameController.text.trim()} '
              '${lastNameController.text.trim()}'
          .trim();
}
