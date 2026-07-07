import 'dart:ui';

class AppResponsive {
  const AppResponsive._();

  static int gridCrossAxisCount(Size size) => 2;

  static double gridChildAspectRatio(Size size) => 0.76;

  static int gridSkeletonCount(Size size) => 6;

  static int cardCacheWidth(Size size, double devicePixelRatio) {
    final cardWidth = size.width / 2;
    return (cardWidth * devicePixelRatio).toInt();
  }
}
