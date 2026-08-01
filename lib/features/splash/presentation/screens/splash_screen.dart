import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/auth/auth_manager.dart';
import '../../../../config/di/di.dart';
import '../../../../config/secure_storage/secure_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/assets.dart';

import '../../../profile/domain/use_cases/get_profile_data_usecase.dart';

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

  bool _isNavigating = false;

  Future<void> _navigateAfterSplash() async {
    final results = await Future.wait([
      Future<void>.delayed(const Duration(milliseconds: 1500)),
      _resolveDestination(),
    ]);

    if (!mounted || _isNavigating) return;
    _isNavigating = true;
    final destination = results[1] as String;
    Navigator.pushNamedAndRemoveUntil(context, destination, (route) => false);
  }

  Future<String> _resolveDestination() async {
    final storage = getIt<SecureStorageService>();
    final authManager = getIt<AuthManager>();

    final hasSeenOnboarding = await storage.readSeenOnboarding();
    if (!hasSeenOnboarding) {
      return AppRoutsName.onBoarding;
    }

    if (authManager.isLoggedIn) {
      try {
        await getIt<GetProfileDataUseCase>().getProfileData();
      } catch (_) {}
      return AppRoutsName.sectionApp;
    }

    return AppRoutsName.loginScreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Lottie.asset(
          Assets.logo,
          delegates: LottieDelegates(
            values: [
              ValueDelegate.color(const ['*'], value: AppColors.black),
            ],
          ),
        ),
      ),
    );
  }
}
