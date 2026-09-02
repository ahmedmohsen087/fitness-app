import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/values/assets.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.assetsIconsFacebook, width: 32, height: 32),
        SvgPicture.asset(Assets.assetsIconsGoogle, width: 32, height: 32),
        SvgPicture.asset(Assets.assetsIconsApple, width: 32, height: 32),
      ],
    );
  }
}
