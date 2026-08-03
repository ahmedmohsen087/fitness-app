import '../../core/utils/error/error_handler.dart';
import '../base_response/base_response.dart';

abstract class BaseRepository {
  const BaseRepository();

  Future<BaseResponse<Entity>> execute<Model, Entity>({
    required Future<BaseResponse<Model>> Function() request,
    required Entity Function(Model model) mapper,
    String? Function(Object error)? errorCode,
  }) async {
    try {
      return switch (await request()) {
        SuccessBaseResponse<Model>(data: final data) => SuccessBaseResponse(
          data: mapper(data),
        ),
        ErrorBaseResponse<Model>(errorMessage: final message) =>
          ErrorBaseResponse(errorMessage: message),
      };
    } catch (error) {
      return ErrorBaseResponse(
        errorMessage: errorCode?.call(error) ?? ErrorHandler.handle(error),
      );
    }
  }
}
