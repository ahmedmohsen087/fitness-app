import 'package:fitness_app/core/reusable_widgets/app_background_scaffold.dart';
import 'package:flutter/material.dart';

import '../../../../core/values/assets.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppBackgroundScaffold(
      imagePath: Assets.authBackground,
      child: child,
    );
  }
}
