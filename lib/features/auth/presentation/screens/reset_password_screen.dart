import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:flutter/material.dart';
import '../../../../core/values/assets.dart';
import '../widgets/reset_password_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackgroundScaffold(
      imagePath: Assets.authBackground,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 60,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(Assets.appLogo, height: 60, fit: BoxFit.contain),
            ),
            const ResetPasswordWidget(),
          ],
        ),
      ),
    );
  }
}
