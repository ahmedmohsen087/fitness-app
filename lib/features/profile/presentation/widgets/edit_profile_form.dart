import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/register_constants.dart';
import 'edit_profile_value_tile.dart';
import 'editable_profile_avatar.dart';

class EditProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final String userName;
  final String imageUrl;
  final String? localPhotoPath;
  final int weight;
  final FitnessGoal? goal;
  final ActivityLevel? activityLevel;
  final bool isSubmitting;
  final bool isUploadingPhoto;
  final VoidCallback onPickPhoto;
  final ValueChanged<EditProfileField> onEditField;
  final VoidCallback onSubmit;

  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.userName,
    required this.imageUrl,
    required this.localPhotoPath,
    required this.weight,
    required this.goal,
    required this.activityLevel,
    required this.isSubmitting,
    required this.isUploadingPhoto,
    required this.onPickPhoto,
    required this.onEditField,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
        child: Column(
          children: [
            EditableProfileAvatar(
              imageUrl: imageUrl,
              localPhotoPath: localPhotoPath,
              isLoading: isUploadingPhoto,
              onTap: onPickPhoto,
            ),
            const SizedBox(height: 4),
            Text(userName, style: TextStyles.authHeadline),
            const SizedBox(height: 28),
            _ProfileTextField(
              controller: firstNameController,
              hintText: AppStrings.firstName,
              icon: Icons.person_outline,
              validator: AppValidations.validateFirstName,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            _ProfileTextField(
              controller: lastNameController,
              hintText: AppStrings.lastName,
              icon: Icons.person_outline,
              validator: AppValidations.validateLastName,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            _ProfileTextField(
              controller: emailController,
              hintText: AppStrings.email,
              icon: Icons.mail_outline,
              validator: AppValidations.validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            EditProfileValueTile(
              title: AppStrings.yourWeight,
              value: '$weight ${AppStrings.kilogram}',
              onTap: () => onEditField(EditProfileField.weight),
            ),
            const SizedBox(height: 16),
            EditProfileValueTile(
              title: AppStrings.yourGoal,
              value: _goalLabel(goal),
              onTap: () => onEditField(EditProfileField.goal),
            ),
            const SizedBox(height: 16),
            EditProfileValueTile(
              title: AppStrings.yourActivityLevel,
              value: _activityLabel(activityLevel),
              onTap: () => onEditField(EditProfileField.activity),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                style: AppTheme.authPrimaryButtonStyle,
                child: isSubmitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        AppStrings.saveChanges,
                        style: TextStyles.authButton,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _goalLabel(FitnessGoal? goal) => switch (goal) {
    FitnessGoal.gainWeight => AppStrings.goalGainWeight,
    FitnessGoal.loseWeight => AppStrings.goalLoseWeight,
    FitnessGoal.getFitter => AppStrings.goalGetFitter,
    FitnessGoal.gainMoreFlexible => AppStrings.goalGainMoreFlexible,
    FitnessGoal.learnTheBasic => AppStrings.goalLearnTheBasic,
    null => '',
  };

  String _activityLabel(ActivityLevel? level) => switch (level) {
    ActivityLevel.level1 => AppStrings.activityLevelRookie,
    ActivityLevel.level2 => AppStrings.activityLevelBeginner,
    ActivityLevel.level3 => AppStrings.activityLevelIntermediate,
    ActivityLevel.level4 => AppStrings.activityLevelAdvance,
    ActivityLevel.level5 => AppStrings.activityLevelTrueBeast,
    null => '',
  };
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;

  const _ProfileTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.validator,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      style: TextStyles.authField.copyWith(color: AppColors.white),
      decoration: AppTheme.authInputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.lightGray, size: 20),
      ),
    );
  }
}

enum EditProfileField { weight, goal, activity }
