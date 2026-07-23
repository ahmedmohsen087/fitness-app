// lib/features/auth/presentation/widgets/email_verification_widget.dart
import 'package:fitness_app/features/auth/api/request_models/verify_reset_code_request_model.dart';
import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:fitness_app/features/auth/presentation/widgets/otp_input_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/reusable_widgets/app_toast.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../api/request_models/forget_password_email_request_model.dart';
import '../view_models/forget_password_view_model/forget_password_events.dart';
import '../view_models/forget_password_view_model/forget_password_states.dart';
import '../view_models/forget_password_view_model/forget_password_view_model.dart';

class EmailVerificationWidget extends StatefulWidget {
  const EmailVerificationWidget({super.key});

  @override
  State<EmailVerificationWidget> createState() =>
      _EmailVerificationWidgetState();
}

class _EmailVerificationWidgetState extends State<EmailVerificationWidget> {
  final TapGestureRecognizer _resendRecognizer = TapGestureRecognizer();
  String _otp = '';
  String? _otpError;

  @override
  void dispose() {
    _resendRecognizer.dispose();
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
            ForgetPasswordRecoveryStep.verify) {
          Navigator.pushNamed(
            context,
            AppRoutsName.resetPassword,
            arguments: context.read<ForgetPasswordViewModel>(),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.forgetPasswordState.isLoading;
        _resendRecognizer.onTap = isLoading ? null : _onResend;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.lightBlack.withValues(alpha: .40),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.otpCodeLabel, style: TextStyles.bodyRegular16),
                Text(
                  AppStrings.enterYourOtpCheckYourEmail,
                  style: TextStyles.bodyRegular24,
                ),
                OtpInputField(
                  onChanged: (value) {
                    setState(() {
                      _otp = value;
                      _otpError = null;
                    });
                  },
                ),
                if (_otpError != null)
                  Text(_otpError!, style: TextStyles.errorTextFieldStyle),
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
                        : Text(AppStrings.confirm),
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: '${AppStrings.didntReceiveCode} ',
                      style: TextStyles.bodyRegular12.copyWith(
                        color: AppColors.white,
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.resendCode,
                          style: TextStyles.bodyRegularUnderLine13.copyWith(
                            color: AppColors.orange,
                            decorationColor: AppColors.orange,
                          ),
                          recognizer: _resendRecognizer,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSubmit() {
    final validationError = AppValidations.validateOtp(_otp);
    if (validationError != null) {
      setState(() => _otpError = validationError);
      return;
    }

    final viewModel = context.read<ForgetPasswordViewModel>();

    viewModel.doEvent(
      VerifyOtpEvent(
        verifyResetCodeRequestModel: VerifyResetCodeRequestModel(
          resetCode: _otp,
        ),
      ),
    );
  }

  void _onResend() {
    final viewModel = context.read<ForgetPasswordViewModel>();

    viewModel.doEvent(
      SendForgetPasswordEmailEvent(
        forgetPasswordEmailRequestModel: ForgetPasswordEmailRequestModel(
          email: viewModel.userEmail ?? '',
        ),
      ),
    );
  }
}
