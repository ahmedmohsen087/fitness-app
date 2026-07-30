import 'dart:io';

import 'package:flutter/material.dart';

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
    final localPath = localPhotoPath;
    final ImageProvider<Object>? image =
        localPath != null && localPath.isNotEmpty
        ? FileImage(File(localPath))
        : imageUrl.isNotEmpty
        ? NetworkImage(imageUrl)
        : null;

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
                backgroundImage: image,
                child: image == null
                    ? const Icon(Icons.person, size: 50, color: AppColors.white)
                    : null,
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
