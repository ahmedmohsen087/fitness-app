import '../entities/compressed_profile_photo_entity.dart';
import '../entities/upload_profile_photo_params.dart';

abstract interface class ProfileImageCompressorContract {
  Future<CompressedProfilePhotoEntity> compress(
    UploadProfilePhotoParams params,
  );
}
