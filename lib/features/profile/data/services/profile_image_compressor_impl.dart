import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/values/app_strings.dart';
import '../../domain/entities/compressed_profile_photo_entity.dart';
import '../../domain/entities/upload_profile_photo_params.dart';
import '../../domain/repository_contract/profile_image_compressor_contract.dart';

@Injectable(as: ProfileImageCompressorContract)
class ProfileImageCompressorImpl implements ProfileImageCompressorContract {
  static const int _maximumUploadBytes = 1024 * 1024;
  static const List<(int, int)> _compressionAttempts = [
    (2048, 85),
    (1600, 75),
    (1280, 65),
    (1024, 55),
    (800, 45),
    (640, 35),
  ];

  @override
  Future<CompressedProfilePhotoEntity> compress(
    UploadProfilePhotoParams params,
  ) async {
    final originalBytes = await File(params.path).readAsBytes();
    if (originalBytes.lengthInBytes <= _maximumUploadBytes) {
      return CompressedProfilePhotoEntity(
        bytes: originalBytes,
        fileName: params.fileName,
      );
    }

    Uint8List? smallestResult;
    for (final (dimension, quality) in _compressionAttempts) {
      final result = await FlutterImageCompress.compressWithFile(
        params.path,
        minWidth: dimension,
        minHeight: dimension,
        quality: quality,
        keepExif: false,
      );
      if (result == null) continue;
      if (smallestResult == null ||
          result.lengthInBytes < smallestResult.lengthInBytes) {
        smallestResult = result;
      }
      if (result.lengthInBytes <= _maximumUploadBytes) {
        return CompressedProfilePhotoEntity(
          bytes: result,
          fileName: params.fileName,
        );
      }
    }

    if (smallestResult == null) {
      throw StateError(AppStrings.profilePhotoCompressionFailed);
    }
    throw StateError(AppStrings.profilePhotoTooLarge);
  }
}
