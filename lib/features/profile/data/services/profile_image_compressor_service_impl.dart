import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/compressed_profile_photo_entity.dart';
import '../../domain/entities/upload_profile_photo_params.dart';
import '../../domain/services/profile_image_compressor_service.dart';

@Injectable(as: ProfileImageCompressorService)
class ProfileImageCompressorServiceImpl
    implements ProfileImageCompressorService {
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
    final file = File(params.path);
    if (await file.length() <= _maximumUploadBytes) {
      return _readOriginal(file, params.fileName);
    }
    return _compressToLimit(params);
  }

  Future<CompressedProfilePhotoEntity> _readOriginal(
    File file,
    String fileName,
  ) async {
    return CompressedProfilePhotoEntity(
      bytes: await file.readAsBytes(),
      fileName: fileName,
    );
  }

  Future<CompressedProfilePhotoEntity> _compressToLimit(
    UploadProfilePhotoParams params,
  ) async {
    var producedResult = false;
    for (final (dimension, quality) in _compressionAttempts) {
      final result = await _compress(params.path, dimension, quality);
      if (result == null) continue;
      producedResult = true;
      if (result.lengthInBytes <= _maximumUploadBytes) {
        return CompressedProfilePhotoEntity(
          bytes: result,
          fileName: params.fileName,
        );
      }
    }

    final failure = producedResult
        ? ProfileImageCompressionFailure.photoTooLarge
        : ProfileImageCompressionFailure.compressionFailed;
    throw ProfileImageCompressionException(failure);
  }

  Future<Uint8List?> _compress(String path, int dimension, int quality) {
    return FlutterImageCompress.compressWithFile(
      path,
      minWidth: dimension,
      minHeight: dimension,
      quality: quality,
      keepExif: false,
    );
  }
}
