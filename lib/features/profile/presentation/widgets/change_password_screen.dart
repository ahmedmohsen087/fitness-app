import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:fitness_app/core/reusable_widgets/app_toast.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
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
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _obscureOldPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureNewPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    _obscureOldPassword.dispose();
    _obscureNewPassword.dispose();
    _obscureConfirmPassword.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: AppColors.white.withValues(alpha: .3),
        width: 1,
      ),
    );

    return InputDecoration(
      filled: true,
      fillColor: AppColors.black.withValues(alpha: .25),
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.white.withValues(alpha: .5),
        fontSize: 14,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Icon(
          prefixIcon,
          color: AppColors.white.withValues(alpha: .6),
          size: 18,
        ),
      ),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.red, width: 1.5),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundScaffold(
      imagePath: Assets.mainBackground,
      child: BlocConsumer<ChangePasswordViewModel, ChangePasswordState>(
        listener: (context, state) {
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
        },
        builder: (context, state) {
          final cpState = state.changePasswordState;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: state.autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Image.asset(Assets.appLogo, height: 60),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 32),

                      // Old Password
                      ValueListenableBuilder<bool>(
                        valueListenable: _obscureOldPassword,
                        builder: (context, obscure, _) {
                          return TextFormField(
                            controller: oldPasswordController,
                            obscureText: obscure,
                            style: const TextStyle(color: AppColors.white),
                            decoration: _buildInputDecoration(
                              hintText: AppStrings.oldPassword,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.white.withValues(alpha: .6),
                                  size: 18,
                                ),
                                onPressed: () {
                                  _obscureOldPassword.value = !obscure;
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.pleaseEnterOldPassword;
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // New Password
                      ValueListenableBuilder<bool>(
                        valueListenable: _obscureNewPassword,
                        builder: (context, obscure, _) {
                          return TextFormField(
                            controller: newPasswordController,
                            obscureText: obscure,
                            style: const TextStyle(color: AppColors.white),
                            decoration: _buildInputDecoration(
                              hintText: AppStrings.newPassword,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.white.withValues(alpha: .6),
                                  size: 18,
                                ),
                                onPressed: () {
                                  _obscureNewPassword.value = !obscure;
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 8) {
                                return AppStrings.passwordMustBeAtLeast8Chars;
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      ValueListenableBuilder<bool>(
                        valueListenable: _obscureConfirmPassword,
                        builder: (context, obscure, _) {
                          return TextFormField(
                            controller: confirmPasswordController,
                            obscureText: obscure,
                            style: const TextStyle(color: AppColors.white),
                            decoration: _buildInputDecoration(
                              hintText: AppStrings.confirmPassword,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.white.withValues(alpha: .6),
                                  size: 18,
                                ),
                                onPressed: () {
                                  _obscureConfirmPassword.value = !obscure;
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value != newPasswordController.text) {
                                return AppStrings.passwordsDoNotMatch;
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 40),

                      // Done Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: cpState.isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context
                                        .read<ChangePasswordViewModel>()
                                        .doEvent(
                                          ChangePasswordRequestEvent(
                                            password:
                                                oldPasswordController.text,
                                            newPassword:
                                                newPasswordController.text,
                                          ),
                                        );
                                  } else {
                                    context
                                        .read<ChangePasswordViewModel>()
                                        .doEvent(EnableAutoValidateEvent());
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: cpState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  AppStrings.done,
                                  style: TextStyles.buttonTextStyle,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
