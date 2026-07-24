abstract class ApiEndpoints {
  static const String baseUrl = "https://fitness.elevateegy.com/api/v1/auth/";
  static const String mealDbBaseUrl =
      "https://www.themealdb.com/api/json/v1/1/";
  static const String signUp = "signup";
  static const String login = "${baseUrl}signin";
  static const String muscles =
      "https://fitness.elevateegy.com/api/v1/muscles/random";
  static const String musclesGroup =
      "https://fitness.elevateegy.com/api/v1/muscles";
  static const String musclesGroupId =
      "https://fitness.elevateegy.com/api/v1/musclesGroup/{id}";
  static const String recommendationFood = "${mealDbBaseUrl}categories.php";
  static const String mealsByCategory = "${mealDbBaseUrl}filter.php";
  static const String mealDetails = "${mealDbBaseUrl}lookup.php";
  static const String forgetPassword = "forgotPassword";
  static const String verifyOtp = "verifyResetCode";
  static const String resetPassword = "resetPassword";
}
