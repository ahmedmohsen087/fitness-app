abstract class ApiEndpoints {
  static const String baseUrl = "https://fitness.elevateegy.com/api/v1/auth/";
  static const String login = "${baseUrl}signin";
  static const String muscles = "https://fitness.elevateegy.com/api/v1/muscles/random";
  static const String musclesGroup = "https://fitness.elevateegy.com/api/v1/muscles";
  static const String musclesGroupId = "https://fitness.elevateegy.com/api/v1/musclesGroup/{id}";
}
