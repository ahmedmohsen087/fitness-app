import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/reusable_widgets/custom_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/app_strings.dart';

class EditableProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final String? localPhotoPath;
  final bool isLoading;
  final VoidCallback? onTap;

  const EditableProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.localPhotoPath,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppStrings.selectProfilePhoto,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: isLoading ? null : onTap,
        child: SizedBox.square(
          dimension: 112,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.lightBlack,
                child: ClipOval(
                  child: _ProfileImage(
                    localPhotoPath: localPhotoPath,
                    imageUrl: imageUrl,
                  ),
                ),
              ),
              if (isLoading)
                const SizedBox.square(
                  dimension: 42,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.orange,
                  ),
                ),
              const PositionedDirectional(
                top: 2,
                end: 2,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: AppColors.orange,
                  child: Icon(
                    Icons.edit_outlined,
                    color: AppColors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  final String? localPhotoPath;
  final String imageUrl;

  const _ProfileImage({required this.localPhotoPath, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final localPath = localPhotoPath?.trim();
    if (localPath != null && localPath.isNotEmpty) {
      return Image.file(
        File(localPath),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const _ProfilePlaceholder(),
      );
    }
    if (imageUrl.trim().isNotEmpty) {
      return CustomNetworkImage(
        imageUrl: imageUrl.trim(),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
    return const _ProfilePlaceholder();
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.lightBlack,
      child: SizedBox.square(
        dimension: 100,
        child: Icon(Icons.person, size: 50, color: AppColors.white),
      ),
    );
  }
}
