import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../config/di/di.dart';
import '../../../../config/secure_storage/secure_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_routs_name.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/values/assets.dart';
import '../widgets/on_boarding_item.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController boardController = PageController();

  int currentIndex = 0;

  bool get _isLast => currentIndex == items.length - 1;

  final List<({String image, String title, String description})> items = [
    (
      image: Assets.onBoarding1,
      title: AppStrings.titleOnBoarding1,
      description: AppStrings.titleOnBoarding,
    ),
    (
      image: Assets.onBoarding2,
      title: AppStrings.titleOnBoarding2,
      description: AppStrings.titleOnBoarding,
    ),
    (
      image: Assets.onBoarding3,
      title: AppStrings.titleOnBoarding3,
      description: AppStrings.titleOnBoarding,
    ),
  ];

  @override
  void dispose() {
    boardController.dispose();
    super.dispose();
  }

  bool _isNavigating = false;

  Future<void> _finishOnboarding() async {
    if (_isNavigating) return;
    _isNavigating = true;
    await getIt<SecureStorageService>().writeSeenOnboarding(true);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutsName.loginScreen,
      (route) => false,
    );
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

          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: GestureDetector(
                  onTap: _finishOnboarding,
                  child: Text(
                    AppStrings.skip,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: .75),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              decoration: BoxDecoration(
                color: AppColors.lightBlack.withValues(alpha: .75),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(35),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      items[currentIndex].title,
                      style: TextStyles.bodyRegular24.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      items[currentIndex].description,
                      style: TextStyles.bodyRegular16.copyWith(
                        color: AppColors.white.withValues(alpha: .7),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    SmoothPageIndicator(
                      controller: boardController,
                      count: items.length,
                      effect: ExpandingDotsEffect(
                        dotColor: AppColors.white.withValues(alpha: .4),
                        activeDotColor: AppColors.orange,
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 3,
                      ),
                    ),

                    const SizedBox(height: 24),

                    currentIndex == 0
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orange,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () {
                                boardController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Text(
                                AppStrings.next,
                                style: TextStyles.buttonTextStyle.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    side: BorderSide(
                                      color: AppColors.orange.withValues(
                                        alpha: .7,
                                      ),
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () {
                                    boardController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Text(
                                    AppStrings.back,
                                    style: TextStyles.buttonTextStyle.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.orange,
                                    foregroundColor: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_isLast) {
                                      _finishOnboarding();
                                    } else {
                                      boardController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  child: Text(
                                    _isLast
                                        ? AppStrings.getStarted
                                        : AppStrings.next,
                                    style: TextStyles.buttonTextStyle.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
