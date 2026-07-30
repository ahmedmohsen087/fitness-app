import 'package:equatable/equatable.dart';

class UploadProfilePhotoParams extends Equatable {
  final String path;
  final String fileName;

  const UploadProfilePhotoParams({required this.path, required this.fileName});

  @override
  List<Object?> get props => [path, fileName];
}
