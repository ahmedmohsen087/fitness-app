import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/profile_message_entity.dart';

part 'profile_message_model.g.dart';

@JsonSerializable(createToJson: false)
class ProfileMessageModel {
  final String? message;

  const ProfileMessageModel({this.message});

  factory ProfileMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileMessageModelFromJson(json);

  ProfileMessageEntity toEntity() =>
      ProfileMessageEntity(message: message ?? '');
}
