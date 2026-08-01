import '../entities/upload_profile_photo_params.dart';

abstract interface class ProfilePhotoPickerContract {
  Future<UploadProfilePhotoParams?> pick();
}
