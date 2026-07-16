import '../../values/app_strings.dart';
import 'app_regex.dart';

abstract class AppValidations {
  static String? validateFirstName(String? firstName) {
    if (firstName == null || !AppRegex.isNotEmpty(firstName)) {
      return AppStrings.firstNameRequired;
    }

    if (!AppRegex.isValidName(firstName)) {
      return AppStrings.nameInvalid;
    }

    if (firstName.trim().length < 2) {
      return AppStrings.nameTooShort;
    }

    if (firstName.trim().length > 20) {
      return AppStrings.nameTooLong;
    }

    return null;
  }

  static String? validateLastName(String? lastName) {
    if (lastName == null || !AppRegex.isNotEmpty(lastName)) {
      return AppStrings.lastNameRequired;
    }

    if (!AppRegex.isValidName(lastName)) {
      return AppStrings.nameInvalid;
    }

    if (lastName.trim().length < 2) {
      return AppStrings.nameTooShort;
    }

    if (lastName.trim().length > 20) {
      return AppStrings.nameTooLong;
    }

    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || !AppRegex.isNotEmpty(email)) {
      return AppStrings.emailRequired;
    }

    if (!AppRegex.isValidEmail(email)) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || !AppRegex.isNotEmpty(phone)) {
      return AppStrings.phoneRequired;
    }

    if (!AppRegex.isValidPhoneNumber(phone)) {
      return AppStrings.phoneInvalid;
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || !AppRegex.isNotEmpty(password)) {
      return AppStrings.passwordRequired;
    }

    if (!AppRegex.isValidPassword(password)) {
      return AppStrings.passwordWeak;
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || !AppRegex.isNotEmpty(confirmPassword)) {
      return AppStrings.confirmPasswordRequired;
    }

    if (password == null ||
        !AppRegex.isPasswordMatch(password, confirmPassword)) {
      return AppStrings.passwordDoNotMatch;
    }

    return null;
  }

  static String? validateOtp(String? otp) {
    if (otp == null || !AppRegex.isNotEmpty(otp)) {
      return AppStrings.otpEmpty;
    }

    if (!AppRegex.hasOnlyDigits(otp)) {
      return AppStrings.otpInvalid;
    }

    if (otp.trim().length != AppRegex.otpLength) {
      return AppStrings.otpLength;
    }

    return null;
  }

  static String? validateRequired(String? value, String errorMessage) {
    if (value == null || !AppRegex.isNotEmpty(value)) {
      return errorMessage;
    }
    return null;
  }

  static String? validateNid(String? nid) {
    if (nid == null || !AppRegex.isNotEmpty(nid)) {
      return AppStrings.idNumberRequired;
    }
    if (!RegExp(r'^[0-9]{14}$').hasMatch(nid.trim())) {
      return AppStrings.idNumberRequired;
    }
    return null;
  }
}
