import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/assets.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.lightBlack),
        Image.asset(Assets.authBackGround, fit: BoxFit.cover),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.25, sigmaY: 6.25),
          child: ColoredBox(color: AppColors.black.withValues(alpha: 0.5)),
        ),
        child,
      ],
    );
  }
}
