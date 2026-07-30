import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../theme/app_colors.dart';
import '../utils/app_responsive.dart';
import '../values/app_strings.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final devicePixelRatio = mediaQuery?.devicePixelRatio ?? 1.0;
    final size = mediaQuery?.size ?? const Size(360, 640);

    final computedMemWidth = (width != null && width != double.infinity)
        ? (width! * devicePixelRatio).round()
        : AppResponsive.cardCacheWidth(size, devicePixelRatio);

    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      memCacheWidth: computedMemWidth,
      placeholder: (context, url) => Skeletonizer(
        enabled: true,
        child: Container(
          width: width,
          height: height,
          color: AppColors.lightBlack,
        ),
      ),
      errorWidget: (context, url, error) =>
          _ImageError(imageUrl: imageUrl, width: width, height: height),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }
}

class _ImageError extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const _ImageError({required this.imageUrl, this.width, this.height});

  @override
  State<_ImageError> createState() => _ImageErrorState();
}

class _ImageErrorState extends State<_ImageError> {
  Future<void> _retry() async {
    await CachedNetworkImage.evictFromCache(widget.imageUrl);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: AppColors.lightBlack,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.placeHolder,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.somethingWentWrong,
            style: const TextStyle(fontSize: 10, color: AppColors.placeHolder),
          ),
          const SizedBox(height: 6),
          IconButton(
            onPressed: _retry,
            icon: const Icon(
              Icons.refresh,
              color: AppColors.placeHolder,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
