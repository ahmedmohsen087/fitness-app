import 'package:injectable/injectable.dart';

import '../entities/upload_profile_photo_params.dart';
import '../repository_contract/profile_photo_picker_contract.dart';

@injectable
class PickProfilePhotoUseCase {
  final ProfilePhotoPickerContract _picker;

  PickProfilePhotoUseCase(this._picker);

  Future<UploadProfilePhotoParams?> execute() => _picker.pick();
}
