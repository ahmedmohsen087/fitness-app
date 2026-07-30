import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/upload_profile_photo_params.dart';
import '../../domain/repository_contract/profile_photo_picker_contract.dart';

@Injectable(as: ProfilePhotoPickerContract)
class ProfilePhotoPickerImpl implements ProfilePhotoPickerContract {
  final ImagePicker _imagePicker;

  ProfilePhotoPickerImpl(this._imagePicker);

  @override
  Future<UploadProfilePhotoParams?> pick() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2400,
      maxHeight: 2400,
      requestFullMetadata: false,
    );
    if (image == null) return null;
    return UploadProfilePhotoParams(path: image.path, fileName: image.name);
  }
}
