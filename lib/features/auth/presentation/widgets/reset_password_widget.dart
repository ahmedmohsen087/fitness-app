import 'package:fitness_app/features/auth/api/request_models/reset_password_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/reusable_widgets/app_toast.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../view_models/forget_password_view_model/forget_password_events.dart';
import '../view_models/forget_password_view_model/forget_password_states.dart';
import '../view_models/forget_password_view_model/forget_password_view_model.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({super.key});

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordViewModel, ForgetPasswordState>(
      listener: (context, state) {
        final baseState = state.forgetPasswordState;

        if (baseState.msg != null) {
          AppToast.error(context, baseState.msg!);
          return;
        }

        if (baseState.data?.forgetPasswordRecoveryStep ==
            ForgetPasswordRecoveryStep.reset) {
          AppToast.success(context, AppStrings.passwordChangedSuccessfully);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutsName.loginScreen,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.forgetPasswordState.isLoading;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.lightBlack.withValues(alpha: .40),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.makeSure8CharsOrMore,
                    style: TextStyles.bodyRegular16,
                  ),
                  Text(
                    AppStrings.createNewPasswordTitle,
                    style: TextStyles.bodyRegular24,
                  ),

                  ValueListenableBuilder<bool>(
                    valueListenable: _obscurePassword,
                    builder: (context, obscure, _) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: obscure,
                        validator: (value) =>
                            AppValidations.validatePassword(value ?? ''),
                        style: const TextStyle(color: AppColors.white),
                        decoration: InputDecoration(
                          hintText: AppStrings.newPassword,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: AppColors.placeHolder,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.placeHolder,
                            ),
                            onPressed: () {
                              _obscurePassword.value = !obscure;
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  ValueListenableBuilder<bool>(
                    valueListenable: _obscureConfirmPassword,
                    builder: (context, obscure, _) {
                      return TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: obscure,
                        validator: (value) =>
                            AppValidations.validateConfirmPassword(
                              _passwordController.text,
                              value ?? '',
                            ),
                        style: const TextStyle(color: AppColors.white),
                        decoration: InputDecoration(
                          hintText: AppStrings.confirmPassword,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: AppColors.placeHolder,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.placeHolder,
                            ),
                            onPressed: () {
                              _obscureConfirmPassword.value = !obscure;
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onSubmit,
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : Text(AppStrings.doneButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgetPasswordViewModel>().doEvent(
        ResetPasswordEvent(
          resetPasswordRequestModel: ResetPasswordRequestModel(
            password: _passwordController.text,
            newPassword: _confirmPasswordController.text,
          ),
        ),
      );
    }
  }
}
