import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/text_styles.dart';
import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_events.dart';
import 'package:fitness_app/features/auth/presentation/view_models/logout_view_model/logout_view_model.dart';
import 'package:flutter/material.dart';

class LogoutDialog {
  static Future<void> show(BuildContext context, LogoutViewModel viewModel) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _buildDialog(context, dialogContext, viewModel),
    );
  }

  static Widget _buildDialog(
    BuildContext parentContext,
    BuildContext dialogContext,
    LogoutViewModel viewModel,
  ) {
    return Dialog(
      backgroundColor: AppColors.lightBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            const SizedBox(height: 24),
            _buildActions(parentContext, dialogContext, viewModel),
          ],
        ),
      ),
    );
  }

  static Widget _buildTitle() {
    return Text(
      AppStrings.areYouSureYouWantToLogout,
      textAlign: TextAlign.center,
      style: TextStyles.bodyMedium18.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget _buildActions(
    BuildContext parentContext,
    BuildContext dialogContext,
    LogoutViewModel viewModel,
  ) {
    return Row(
      children: [
        Expanded(child: _buildCancelButton(dialogContext)),
        const SizedBox(width: 16),
        Expanded(child: _buildConfirmButton(parentContext, viewModel)),
      ],
    );
  }

  static Widget _buildCancelButton(BuildContext dialogContext) {
    return OutlinedButton(
      onPressed: () => Navigator.pop(dialogContext),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.orange),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        AppStrings.no,
        style: TextStyles.bodyRegular14.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _buildConfirmButton(
    BuildContext parentContext,
    LogoutViewModel viewModel,
  ) {
    return ElevatedButton(
      onPressed: () => _onConfirmLogout(parentContext, viewModel),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        AppStrings.yes,
        style: TextStyles.bodyRegular14.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static void _onConfirmLogout(
    BuildContext context,
    LogoutViewModel viewModel,
  ) {
    viewModel.doEvent(LogoutRequestEvent());
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutsName.loginScreen,
      (route) => false,
    );
  }
}
