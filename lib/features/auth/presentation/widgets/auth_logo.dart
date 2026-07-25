import 'package:flutter/material.dart';

import '../../../../core/values/assets.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.appLogo,
      width: 70,
      height: 48,
      fit: BoxFit.contain,
    );
  }
}
