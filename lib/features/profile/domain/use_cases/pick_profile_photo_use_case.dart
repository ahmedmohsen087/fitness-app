import 'package:injectable/injectable.dart';

import '../entities/upload_profile_photo_params.dart';
import '../services/profile_photo_picker_service.dart';

@injectable
class PickProfilePhotoUseCase {
  final ProfilePhotoPickerService _picker;

  PickProfilePhotoUseCase(this._picker);

  Future<UploadProfilePhotoParams?> execute() => _picker.pick();
}
