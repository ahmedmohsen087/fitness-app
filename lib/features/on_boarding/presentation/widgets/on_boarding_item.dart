import 'package:flutter/material.dart';
import '../../../../core/values/assets.dart';

class OnBoardingItem extends StatelessWidget {
  final String image;

  const OnBoardingItem({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.onBoardingBackGround),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .60,
          child: Image.asset(
            image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}