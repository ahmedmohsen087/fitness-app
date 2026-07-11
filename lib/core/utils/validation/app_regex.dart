abstract class AppRegex {
  static const int otpLength = 4;

  static bool isNotEmpty(String value) => value.trim().isNotEmpty;

  static bool hasOnlyDigits(String value) =>
      RegExp(r'^[0-9]+$').hasMatch(value.trim());

  static bool isValidLength(String value, int min, int max) {
    final length = value.trim().length;
    return length >= min && length <= max;
  }

  static bool isValidName(String name) {
    return RegExp(r'^[a-zA-Z؀-ۿ\s\-]+$').hasMatch(name.trim());
  }

  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',
    ).hasMatch(email.trim());
  }

  static bool isValidPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\s+'), '').trim();

    final regex = RegExp(r'^(\+20|0)1[0125][0-9]{8}$');
    return regex.hasMatch(cleaned);
  }

  static bool hasLowerCase(String password) =>
      RegExp(r'(?=.*[a-z])').hasMatch(password);

  static bool hasUpperCase(String password) =>
      RegExp(r'(?=.*[A-Z])').hasMatch(password);

  static bool hasNumber(String password) =>
      RegExp(r'(?=.*\d)').hasMatch(password);

  static bool hasSpecialCharacter(String password) =>
      RegExp(r'(?=.*[#?!@$%^&*-])').hasMatch(password);

  static bool hasMinLength(String password) => password.length >= 8;

  static bool isValidPassword(String password) {
    return hasMinLength(password) &&
        hasUpperCase(password) &&
        hasLowerCase(password) &&
        hasNumber(password) &&
        hasSpecialCharacter(password);
  }

  static bool isPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static bool isValidOtp(String otp) {
    return RegExp('^[0-9]{$otpLength}\$').hasMatch(otp.trim());
  }

  static int passwordStrength(String password) {
    int score = 0;

    if (hasMinLength(password)) score++;
    if (hasLowerCase(password)) score++;
    if (hasUpperCase(password)) score++;
    if (hasNumber(password)) score++;
    if (hasSpecialCharacter(password)) score++;

    return score;
  }
}
