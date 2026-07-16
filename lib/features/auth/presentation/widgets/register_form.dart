import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_strings.dart';
import '../view_model/register_state.dart';
import '../view_model/register_view_model.dart';
import 'auth_primary_button.dart';
import 'social_login_row.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onRegister;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Text(AppStrings.register, style: TextStyles.authTitle),
          const SizedBox(height: 16),
          _AuthTextField(
            controller: firstNameController,
            hintText: AppStrings.firstName,
            icon: Icons.person_outline,
            keyboardType: TextInputType.name,
            validator: AppValidations.validateFirstName,
          ),
          const SizedBox(height: 16),
          _AuthTextField(
            controller: lastNameController,
            hintText: AppStrings.lastName,
            icon: Icons.person_outline,
            keyboardType: TextInputType.name,
            validator: AppValidations.validateLastName,
          ),
          const SizedBox(height: 16),
          _AuthTextField(
            controller: emailController,
            hintText: AppStrings.email,
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: AppValidations.validateEmail,
          ),
          const SizedBox(height: 16),
          _AuthTextField(
            controller: passwordController,
            hintText: AppStrings.password,
            icon: Icons.lock_outline,
            obscureText: obscurePassword,
            validator: AppValidations.validatePassword,
            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 20, height: 20),
              onPressed: onTogglePassword,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _OrDivider(),
          const SizedBox(height: 24),
          const SocialLoginRow(),
          const SizedBox(height: 24),
          _RegisterButton(onPressed: onRegister),
          const SizedBox(height: 8),
          const _LoginLink(),
        ],
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?) validator;
  final Widget? suffixIcon;

  const _AuthTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: AppColors.grey),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 311),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyles.authField.copyWith(color: AppColors.white),
        validator: validator,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyles.authField,
          prefixIcon: Icon(icon, size: 20, color: AppColors.white),
          prefixIconConstraints: const BoxConstraints.tightFor(
            width: 44,
            height: 20,
          ),
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints.tightFor(
            width: 36,
            height: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: AppColors.white),
          ),
          errorBorder: border.copyWith(
            borderSide: const BorderSide(color: AppColors.red),
          ),
          focusedErrorBorder: border.copyWith(
            borderSide: const BorderSide(color: AppColors.red),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 80, child: Divider(color: AppColors.lightGray)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(AppStrings.or, style: TextStyles.authField),
        ),
        const SizedBox(width: 80, child: Divider(color: AppColors.lightGray)),
      ],
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RegisterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterViewModel, RegisterState>(
      buildWhen: (previous, current) =>
          previous.submitState.isLoading != current.submitState.isLoading,
      builder: (context, state) => AuthPrimaryButton(
        width: 311,
        label: AppStrings.register,
        onPressed: onPressed,
        isLoading: state.submitState.isLoading,
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.alreadyHaveAnAccount, style: TextStyles.authFooter),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Text(AppStrings.login, style: TextStyles.authFooterLink),
        ),
      ],
    );
  }
}
