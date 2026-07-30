import 'package:flutter/material.dart';

import '../../../../core/values/assets.dart';

class OnBoardingItem extends StatelessWidget {
  final String image;

  const OnBoardingItem({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.onboardingBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Align(
          alignment: const Alignment(0, -0.3),
          child: FractionallySizedBox(
            heightFactor: 0.58,
            child: Image.asset(image, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
