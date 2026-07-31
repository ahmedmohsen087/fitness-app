import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/reusable_widgets/app_toast.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/utils/validation/app_validations.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/assets.dart';
import 'package:fitness_app/features/profile/presentation/view_models/change_password_view_model/change_password_events.dart';
import 'package:fitness_app/features/profile/presentation/view_models/change_password_view_model/change_password_states.dart';
import 'package:fitness_app/features/profile/presentation/view_models/change_password_view_model/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _obscureOldPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureNewPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _obscureOldPassword.dispose();
    _obscureNewPassword.dispose();
    _obscureConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundScaffold(
      imagePath: Assets.mainBackground,
      child: BlocConsumer<ChangePasswordViewModel, ChangePasswordState>(
        listener: _handleStateListener,
        builder: _buildContent,
      ),
    );
  }

  void _handleStateListener(BuildContext context, ChangePasswordState state) {
    final cpState = state.changePasswordState;
    if (!cpState.isLoading && cpState.data != null) {
      AppToast.success(
        context,
        cpState.data?.message ?? AppStrings.success,
      );
      Navigator.pop(context);
    } else if (!cpState.isLoading && cpState.msg != null) {
      AppToast.error(context, cpState.msg!);
    }
  }

  Widget _buildContent(BuildContext context, ChangePasswordState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: state.autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: _buildFormColumn(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildFormColumn(BuildContext context, ChangePasswordState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderLogo(),
        const SizedBox(height: 16),
        _buildHeaderTitle(),
        const SizedBox(height: 32),
        _buildOldPasswordField(),
        const SizedBox(height: 16),
        _buildNewPasswordField(),
        const SizedBox(height: 16),
        _buildConfirmPasswordField(),
        const SizedBox(height: 40),
        _buildSubmitButton(context, state),
      ],
    );
  }

  Widget _buildHeaderLogo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Image.asset(Assets.appLogo, height: 60),
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.makeSure8CharsOrMore,
          style: TextStyles.bodyRegular16.copyWith(
            color: AppColors.lightGray,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.changePassword,
          style: TextStyles.bodyRegular20.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildOldPasswordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureOldPassword,
      builder: (context, obscure, _) {
        return TextFormField(
          controller: _oldPasswordController,
          obscureText: obscure,
          style: const TextStyle(color: AppColors.white),
          decoration: AppTheme.roundedInputDecoration(
            hintText: AppStrings.oldPassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: _buildSuffixIconButton(
              obscure: obscure,
              onPressed: () =>
                  _obscureOldPassword.value = !_obscureOldPassword.value,
            ),
          ),
          validator: (value) => AppValidations.validateRequired(
            value,
            AppStrings.pleaseEnterOldPassword,
          ),
        );
      },
    );
  }

  Widget _buildNewPasswordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureNewPassword,
      builder: (context, obscure, _) {
        return TextFormField(
          controller: _newPasswordController,
          obscureText: obscure,
          style: const TextStyle(color: AppColors.white),
          decoration: AppTheme.roundedInputDecoration(
            hintText: AppStrings.newPassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: _buildSuffixIconButton(
              obscure: obscure,
              onPressed: () =>
                  _obscureNewPassword.value = !_obscureNewPassword.value,
            ),
          ),
          validator: AppValidations.validatePassword,
        );
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureConfirmPassword,
      builder: (context, obscure, _) {
        return TextFormField(
          controller: _confirmPasswordController,
          obscureText: obscure,
          style: const TextStyle(color: AppColors.white),
          decoration: AppTheme.roundedInputDecoration(
            hintText: AppStrings.confirmPassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: _buildSuffixIconButton(
              obscure: obscure,
              onPressed: () =>
                  _obscureConfirmPassword.value = !_obscureConfirmPassword.value,
            ),
          ),
          validator: (value) => AppValidations.validateConfirmPassword(
            _newPasswordController.text,
            value,
          ),
        );
      },
    );
  }

  Widget _buildSuffixIconButton({
    required bool obscure,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: AppColors.white.withValues(alpha: .6),
        size: 18,
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildSubmitButton(BuildContext context, ChangePasswordState state) {
    final isLoading = state.changePasswordState.isLoading;
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _onSubmitPressed(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: isLoading ? _buildLoadingIndicator() : _buildSubmitText(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: AppColors.white,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildSubmitText() {
    return Text(
      AppStrings.done,
      style: TextStyles.buttonTextStyle,
    );
  }

  void _onSubmitPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordViewModel>().doEvent(
            ChangePasswordRequestEvent(
              password: _oldPasswordController.text,
              newPassword: _newPasswordController.text,
            ),
          );
    } else {
      context.read<ChangePasswordViewModel>().doEvent(EnableAutoValidateEvent());
    }
  }
}
