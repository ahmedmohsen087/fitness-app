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
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginViewModel, LoginState>(
      listener: (context, state) {
        if (state.loginState.msg != null) {
          AppToast.error(context, state.loginState.msg!);
        } else if (state.loginState.data != null) {
          AppToast.success(
            context,
            AppStrings.loggedSuccessfully,
          );
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
          decoration: BoxDecoration(
            color: AppColors.lightBlack.withValues(alpha: .40),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(50),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 20,
                children: [
                  Text(
                    AppStrings.login,
                    style: TextStyles.bodyRegular24,
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) =>
                        AppValidations.validateEmail(value ?? ''),
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: AppStrings.email,
                      prefixIcon: const Icon(Icons.email, color: AppColors.placeHolder),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: (value) =>
                        AppValidations.validatePassword(value ?? ''),
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: AppStrings.password,
                      prefixIcon: const Icon(Icons.lock, color: AppColors.placeHolder),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.placeHolder,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: AppColors.orange,
                          checkColor: AppColors.white,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? true;
                            });
                            context.read<LoginViewModel>().doEvent(
                                  RememberMeEvent(rememberMe: _rememberMe),
                                );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.rememberMe,
                        style: TextStyles.bodyRegular12.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        AppStrings.forgetPassword,
                        style: TextStyles.bodyRegular12.copyWith(
                          color: AppColors.orange,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.orange,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: AppColors.white,
                          thickness: 1.5,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppStrings.or,
                        style: TextStyles.bodyRegular16,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Divider(
                          color: AppColors.white,
                          thickness: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const LoginWithGoogle(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                // Apply rememberMe setting
                                context.read<LoginViewModel>().doEvent(
                                      RememberMeEvent(rememberMe: _rememberMe),
                                    );
                                // Trigger login
                                context.read<LoginViewModel>().doEvent(
                                      LoginRequestEvent(
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(AppColors.white),
                              ),
                            )
                          : Text(AppStrings.login),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: AppStrings.doNotHaveAnAccountYet,
                      style: TextStyles.bodyRegular16,
                      children: [
                        TextSpan(
                          text: AppStrings.register,
                          style: TextStyles.bodyRegular16.copyWith(
                            color: AppColors.orange,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.orange,
                          ),
                          // recognizer: TapGestureRecognizer()
                          //   ..onTap = () =>
                          //       Navigator.pushNamed(context, AppRoutsName.registerScreen),
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
