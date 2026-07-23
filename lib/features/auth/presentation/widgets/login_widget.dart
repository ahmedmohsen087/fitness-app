import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/reusable_widgets/app_toast.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../api/request_models/login_request_model.dart';
import '../screens/login_with_google.dart';
import '../view_models/login_events.dart';
import '../view_models/login_state.dart';
import '../view_models/login_view_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> _rememberMe = ValueNotifier(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    _rememberMe.dispose();
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
    return BlocConsumer<LoginViewModel, LoginState>(
      listenWhen: (previous, current) =>
          previous.loginState != current.loginState,
      listener: (context, state) {
        if (state.loginState.msg != null) {
          AppToast.error(context, state.loginState.msg!);
        } else if (state.loginState.data != null) {
          AppToast.success(context, AppStrings.loggedSuccessfully);

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutsName.sectionApp,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.loginState.isLoading;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.lightBlack.withValues(alpha: .55),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.login,
                    style: TextStyles.bodyRegular24.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  /// Email
                  TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        AppValidations.validateEmail(value ?? ''),
                    style: const TextStyle(color: AppColors.white),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: _buildInputDecoration(
                      hintText: AppStrings.email,
                      prefixIcon: Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// Password
                  ValueListenableBuilder<bool>(
                    valueListenable: _obscurePassword,
                    builder: (context, obscure, _) {
                      return TextFormField(
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: obscure,
                        validator: (value) =>
                            AppValidations.validatePassword(value ?? ''),
                        style: const TextStyle(color: AppColors.white),
                        textInputAction: TextInputAction.done,
                        decoration: _buildInputDecoration(
                          hintText: AppStrings.password,
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
                              _obscurePassword.value = !obscure;
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  /// Remember me & Forgot Password
                  Row(
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: _rememberMe,
                        builder: (context, rememberMe, _) {
                          return SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: rememberMe,
                              activeColor: AppColors.orange,
                              checkColor: AppColors.white,
                              side: BorderSide(
                                color: AppColors.white.withValues(alpha: .6),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (value) {
                                _rememberMe.value = value ?? false;
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _rememberMe.value = !_rememberMe.value;
                        },
                        child: Text(
                          AppStrings.rememberMe,
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: .9),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          // Forgot password navigation
                        },
                        child: Text(
                          AppStrings.forgetPassword,
                          style: const TextStyle(
                            color: AppColors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.white.withValues(alpha: .3),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text(
                          AppStrings.or,
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: .7),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.white.withValues(alpha: .3),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const LoginWithGoogle(),

                  const SizedBox(height: 20),

                  /// Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await context.read<LoginViewModel>().doEvent(
                                  LoginRequestEvent(
                                    rememberMe: _rememberMe.value,
                                    requestModel: LoginRequestModel(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    ),
                                  ),
                                );
                              }
                            },
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
                          : Text(
                              AppStrings.login,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Register
                  RichText(
                    text: TextSpan(
                      text: AppStrings.doNotHaveAnAccountYet,
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: .9),
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.register,
                          style: const TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.orange,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                context,
                                AppRoutsName.register,
                              );
                            },
                        ),
                      ],
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
}
