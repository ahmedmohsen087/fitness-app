import 'package:fitness_app/features/on_boarding/presentation/widgets/on_boarding_item.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController boardController = PageController();

  int currentIndex = 0;

  bool get _isLast => currentIndex == items.length - 1;

  final List<({String image, String title})> items = [
    (image: Assets.onBoarding1, title: AppStrings.titleOnBoarding1),
    (image: Assets.onBoarding2, title: AppStrings.titleOnBoarding2),
    (image: Assets.onBoarding3, title: AppStrings.titleOnBoarding3),
  ];

  @override
  void dispose() {
    boardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: boardController,
            itemCount: items.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              return OnBoardingItem(image: items[index].image);
            },
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .38,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.lightBlack.withValues(alpha: .65),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    items[currentIndex].title,
                    style: TextStyles.bodyRegular24,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    AppStrings.titleOnBoarding,
                    style: TextStyles.bodyRegular16,
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  SmoothPageIndicator(
                    controller: boardController,
                    count: items.length,
                    effect: ExpandingDotsEffect(
                      dotColor: AppColors.white.withValues(alpha: .3),
                      activeDotColor: AppColors.orange,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 3,
                    ),
                  ),

                  const SizedBox(height: 25),

                  currentIndex == 0
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              boardController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(AppStrings.next),
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  boardController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Text(AppStrings.back),
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_isLast) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutsName.loginScreen,
                                    );
                                  } else {
                                    boardController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Text(
                                  _isLast
                                      ? AppStrings.getStarted
                                      : AppStrings.next,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
