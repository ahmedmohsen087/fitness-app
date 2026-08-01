import 'package:fitness_app/core/values/api_parameters.dart';

class OllamaChatMessagePayload {
  final String role;
  final String content;
  final List<String>? images;

  const OllamaChatMessagePayload({
    required this.role,
    required this.content,
    this.images,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      ApiParameters.role: role,
      ApiParameters.content: content,
    };
    if (images != null && images!.isNotEmpty) {
      map[ApiParameters.images] = images;
    }
    return map;
  }
}

class OllamaChatRequestModel {
  final String model;
  final bool stream;
  final List<OllamaChatMessagePayload> messages;
  final Map<String, dynamic>? options;

  const OllamaChatRequestModel({
    this.model = 'gemma3',
    this.stream = false,
    required this.messages,
    this.options = const {'num_predict': 512, 'temperature': 0.7},
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      ApiParameters.model: model,
      ApiParameters.stream: stream,
      ApiParameters.messages: messages.map((m) => m.toJson()).toList(),
    };
    if (options != null) {
      map['options'] = options;
    }
    return map;
  }
}
