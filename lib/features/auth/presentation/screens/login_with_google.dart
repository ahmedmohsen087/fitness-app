import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/values/assets.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Row(
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.facebookLogo),
        SvgPicture.asset(Assets.googleLogo),
        SvgPicture.asset(Assets.appleLogo),
      ],
    );
  }
}
