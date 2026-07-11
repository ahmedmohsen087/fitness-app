import 'package:dio/dio.dart';

import '../../../config/secure_storage/local_storage_exception.dart';
import '../../values/app_strings.dart';

abstract class ErrorHandler {
  static String handle(Object error) {
    if (error is DioException) {
      return _handleDioException(error);
    }

    if (error is LocalStorageException) {
      return error.message;
    }

    return AppStrings.somethingWentWrong;
  }

  static String _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppStrings.connectionTimeout;
      case DioExceptionType.connectionError:
        return AppStrings.noInternetConnection;
      case DioExceptionType.cancel:
        return AppStrings.requestCancelled;
      case DioExceptionType.badCertificate:
        return AppStrings.badCertificate;
      case DioExceptionType.badResponse:
        return _extractApiErrorMessage(error.response?.data) ??
            AppStrings.somethingWentWrong;
      case DioExceptionType.transformTimeout:
        return AppStrings.connectionTimeout;
      case DioExceptionType.unknown:
        return AppStrings.somethingWentWrong;
    }
  }

  static String? _extractApiErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];

      if (message is String && message.isNotEmpty) {
        return message;
      }

      if (message is List && message.isNotEmpty) {
        return message.first.toString();
      }
    }

    return null;
  }
}
