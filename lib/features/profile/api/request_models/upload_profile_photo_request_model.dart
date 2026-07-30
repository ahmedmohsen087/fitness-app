import 'package:dio/dio.dart';

class UploadProfilePhotoRequestModel {
  final MultipartFile photo;

  const UploadProfilePhotoRequestModel({required this.photo});
}
