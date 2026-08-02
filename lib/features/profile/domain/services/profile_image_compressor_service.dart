import '../entities/compressed_profile_photo_entity.dart';
import '../entities/upload_profile_photo_params.dart';

abstract interface class ProfileImageCompressorService {
  Future<CompressedProfilePhotoEntity> compress(
    UploadProfilePhotoParams params,
  );
}

enum ProfileImageCompressionFailure { compressionFailed, photoTooLarge }

class ProfileImageCompressionException implements Exception {
  final ProfileImageCompressionFailure failure;

  const ProfileImageCompressionException(this.failure);
}
