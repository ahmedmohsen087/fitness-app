import 'package:fitness_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/reusable_widgets/app_toast.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/validation/app_validations.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../api/request_models/forget_password_request_model.dart';
import '../view_models/forget_password_view_model/forget_password_events.dart';
import '../view_models/forget_password_view_model/forget_password_states.dart';
import '../view_models/forget_password_view_model/forget_password_view_model.dart';

class ForgetPasswordWidget extends StatefulWidget {
  const ForgetPasswordWidget({super.key});

  @override
  State<ForgetPasswordWidget> createState() => _ForgetPasswordWidgetState();
}

class _ForgetPasswordWidgetState extends State<ForgetPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            ForgetPasswordRecoveryStep.forget) {
          Navigator.pushNamed(
            context,
            AppRoutsName.emailVerificationScreen,
            arguments: context.read<ForgetPasswordViewModel>(),
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
                    AppStrings.enterYourEmailLabel,
                    style: TextStyles.bodyRegular16,
                  ),
                  Text(
                    AppStrings.forgetPasswordTitle,
                    style: TextStyles.bodyRegular24,
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) =>
                        AppValidations.validateEmail(value ?? ''),
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: AppStrings.email,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: AppColors.placeHolder,
                      ),
                    ),
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
                          : Text(AppStrings.sendOtp),
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
        SendForgetPasswordEmailEvent(
          requestModel: ForgetPasswordRequestModel(
            email: _emailController.text.trim(),
          ),
        ),
      );
    }
  }
}
