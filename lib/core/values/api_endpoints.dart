abstract class ApiEndpoints {
  static const String baseUrl = "https://fitness.elevateegy.com/api/v1/auth/";
  static const String forgetPassword = "$baseUrl/forget-password";
  static const String verifyOtp = "$baseUrl/verifyResetCode";
  static const String resetPassword = "$baseUrl/resetPassword";
}
