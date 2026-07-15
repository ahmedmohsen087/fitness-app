import 'package:flutter/material.dart';
import '../../../../core/values/assets.dart';
import '../widgets/email_verification_widget.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Assets.authBackGround, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 60,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(Assets.authLogo),
                  ),
                  const EmailVerificationWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
