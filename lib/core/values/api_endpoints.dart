abstract class ApiEndpoints {
  static const String baseUrl = "https://fitness.elevateegy.com/api/v1/";
  static const String fitnessBaseUrl = baseUrl;
  static const String mealDbBaseUrl = "https://www.themealdb.com/api/json/v1/1/";

  static const String signUp = "auth/signup";
  static const String login = "auth/signin";
  static const String forgetPassword = "auth/forgotPassword";
  static const String verifyOtp = "auth/verifyResetCode";
  static const String resetPassword = "auth/resetPassword";

  static const String getProfile = "auth/profile-data";

  static const String muscles = "muscles/random";
  static const String musclesRandom = "muscles/random";
  static const String musclesGroup = "muscles";
  static const String musclesGroupId = "musclesGroup/{id}";
  static const String musclesGroupById = "musclesGroup/{id}";
  static const String musclesGroupByMuscleGroup = "musclesGroup/by-muscle-group";

  static const String exercisesRandom = "exercises/random";
  static const String difficultyLevelsByPrimeMover = "levels/difficulty-levels/by-prime-mover";
  static const String exercisesByMuscleAndDifficulty = "exercises/by-muscle-difficulty";

  static const String recommendationFood = "https://www.themealdb.com/api/json/v1/1/categories.php";
  static const String mealsByCategory = "https://www.themealdb.com/api/json/v1/1/filter.php";
  static const String mealDetails = "https://www.themealdb.com/api/json/v1/1/lookup.php";
}
