import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/app_launch/app_launch_manager.dart';
import '../../../../config/di/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_navigateAfterSplash());
  }

  Future<void> _navigateAfterSplash() async {
    await Future<void>.delayed(const Duration(seconds: 3));

    final destination = await getIt<AppLaunchManager>().resolveDestination();

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: AppColors.black,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              Assets.logo,
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(const ['*'], value: AppColors.black),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
