import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AuthGlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AuthGlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 17.3, sigmaY: 17.3),
        child: Container(
          width: double.infinity,
          padding: padding,
          color: AppColors.lightBlack.withValues(alpha: 0.1),
          child: child,
        ),
      ),
    );
  }
}
