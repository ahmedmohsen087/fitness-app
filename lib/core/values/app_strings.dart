import 'package:easy_localization/easy_localization.dart';

class AppStrings {
  // General
  static String get routeNotFound => 'routeNotFound'.tr();

  // App Section
  static String get home => 'home'.tr();
  static String get workouts => 'workouts'.tr();
  static String get profile => 'profile'.tr();
  static String get chat => 'chat'.tr();

  // Onboarding actions
  static String get next => 'next'.tr();
  static String get back => 'back'.tr();
  static String get getStarted => 'getStarted'.tr();
  static String get skip => 'skip'.tr();

  // Secure storage - token
  static String get tokenEmpty => 'tokenEmpty'.tr();
  static String get tokenWriteFailed => 'tokenWriteFailed'.tr();
  static String get tokenReadFailed => 'tokenReadFailed'.tr();
  static String get tokenDeleteFailed => 'tokenDeleteFailed'.tr();

  // Secure storage - remember me
  static String get rememberMeWriteFailed => 'rememberMeWriteFailed'.tr();
  static String get rememberMeReadFailed => 'rememberMeReadFailed'.tr();
  static String get rememberMeDeleteFailed => 'rememberMeDeleteFailed'.tr();

  // Secure storage - onboarding
  static String get seenOnboardingWriteFailed =>
      'seenOnboardingWriteFailed'.tr();
  static String get seenOnboardingReadFailed => 'seenOnboardingReadFailed'.tr();
  static String get titleOnBoarding1 => 'ThePriceOfExcellenceIsDiscipline'.tr();
  static String get titleOnBoarding2 => 'fitnessHasNeverBeenSoMuchFun'.tr();
  static String get titleOnBoarding3 => 'NoMoreExcusesDoItNow'.tr();
  static String get titleOnBoarding => 'onBoardingDescription'.tr();

  // Secure storage - general
  static String get clearStorageFailed => 'clearStorageFailed'.tr();

  // Validation - name
  static String get firstNameRequired => 'firstNameRequired'.tr();
  static String get lastNameRequired => 'lastNameRequired'.tr();
  static String get nameInvalid => 'nameInvalid'.tr();
  static String get nameTooShort => 'nameTooShort'.tr();
  static String get nameTooLong => 'nameTooLong'.tr();

  // Validation - email
  static String get emailRequired => 'emailRequired'.tr();
  static String get emailInvalid => 'emailInvalid'.tr();
  static String get email => 'email'.tr();
  static String get enterYourEmail => 'enterYourEmail'.tr();
  static String get emailVerification => 'emailVerification'.tr();
  static String get pleaseEnterYourEmailAssociated =>
      'pleaseEnterYourEmailAssociated'.tr();
  static String get pleaseEnterYourCode => 'pleaseEnterYourCode'.tr();
  static String get didntReceiveCode => 'didntReceiveCode'.tr();
  static String get resend => 'resend'.tr();

  // Validation - phone
  static String get phoneRequired => 'phoneRequired'.tr();
  static String get phoneInvalid => 'phoneInvalid'.tr();

  // Validation - password
  static String get passwordRequired => 'passwordRequired'.tr();
  static String get passwordWeak => 'passwordWeak'.tr();
  static String get confirmPasswordRequired => 'confirmPasswordRequired'.tr();
  static String get passwordDoNotMatch => 'passwordDoNotMatch'.tr();
  static String get password => 'password'.tr();
  static String get forgetPassword => 'forgetPassword'.tr();
  static String get confirm => 'confirm'.tr();
  static String get resetPassword => 'resetPassword'.tr();
  static String get passwordMustNotBeEmpty => 'passwordMustNotBeEmpty'.tr();
  static String get newPassword => 'newPassword'.tr();
  static String get enterYourPassword => 'enterYourPassword'.tr();
  static String get enterPassword => 'enterPassword'.tr();
  static String get confirmPassword => 'confirmPassword'.tr();

  // Validation - otp
  static String get otpEmpty => 'otpEmpty'.tr();
  static String get otpInvalid => 'otpInvalid'.tr();
  static String get otpLength => 'otpLength'.tr();

  // Error handling
  static String get noInternetConnection => 'noInternetConnection'.tr();
  static String get connectionTimeout => 'connectionTimeout'.tr();
  static String get requestCancelled => 'requestCancelled'.tr();
  static String get badCertificate => 'badCertificate'.tr();
  static String get somethingWentWrong => 'somethingWentWrong'.tr();

  // Apply
  static String get idNumber => 'idNumber'.tr();
  static String get idNumberRequired => 'idNumberRequired'.tr();

  // Register - gender
  static String get male => 'male'.tr();
  static String get female => 'female'.tr();

  // Register - goals
  static String get goalGainWeight => 'goalGainWeight'.tr();
  static String get goalLoseWeight => 'goalLoseWeight'.tr();
  static String get goalGetFitter => 'goalGetFitter'.tr();
  static String get goalGainMoreFlexible => 'goalGainMoreFlexible'.tr();
  static String get goalLearnTheBasic => 'goalLearnTheBasic'.tr();

  // Register - activity levels
  static String get activityLevelRookie => 'activityLevelRookie'.tr();
  static String get activityLevelBeginner => 'activityLevelBeginner'.tr();
  static String get activityLevelIntermediate =>
      'activityLevelIntermediate'.tr();
  static String get activityLevelAdvance => 'activityLevelAdvance'.tr();

  // login
  static String get heyThere => 'heyThere'.tr();
  static String get welcomeBACK => 'welcomeBACK'.tr();
  static String get login => 'login'.tr();
  static String get doNotHaveAnAccountYet => 'don\'tHaveAnAccountYet'.tr();
  static String get register => 'register'.tr();
  static String get or => 'or'.tr();
  static String get rememberMe => 'rememberMe'.tr();
  static String get loggedSuccessfully => 'loggedInSuccessfully'.tr();

  // home
  static String get gym => 'gym'.tr();
  static String get trainer => 'trainer'.tr();
  static String get fitness => 'fitness'.tr();
  static String get aerobics => 'aerobics'.tr();
  static String get yoga => 'yoga'.tr();
  static String get category => 'category'.tr();
  static String get hi => 'hi'.tr();
  static String get letsStartYourDay => 'letsStartYourDay'.tr();
  static String get recommendationToDay => 'recommendationToDay'.tr();
  static String get upcomingWorkouts => 'upcomingWorkouts'.tr();
  static String get recommendationForYou => 'recommendationForYou'.tr();
  static String get popularTraining => 'popularTraining'.tr();
  static String get seeAll => 'seeAll'.tr();

  static String get foodRecommendation => 'foodRecommendation'.tr();
  static String get noFoodCategories => 'noFoodCategories'.tr();
  static String get noMealsFound => 'noMealsFound'.tr();
  static String get retry => 'retry'.tr();
  static String get loading => 'loading'.tr();
  static String get ingredients => 'ingredients'.tr();
  static String get cuisine => 'cuisine'.tr();
  static String get country => 'country'.tr();
  static String get tags => 'tags'.tr();
  static String get recipeVideo => 'recipeVideo'.tr();
  static String get close => 'close'.tr();
  static String get videoUnavailable => 'videoUnavailable'.tr();
  static String get noMealDetails => 'noMealDetails'.tr();
  static String get activityLevelTrueBeast => 'activityLevelTrueBeast'.tr();

  // Register screen UI
  static String get createAnAccount => 'createAnAccount'.tr();
  static String get firstName => 'firstName'.tr();
  static String get lastName => 'lastName'.tr();
  static String get alreadyHaveAnAccount => 'alreadyHaveAnAccount'.tr();

  // Gender selection screen UI
  static String get tellUsAboutYourself => 'tellUsAboutYourself'.tr();
  static String get weNeedToKnowYourGender => 'weNeedToKnowYourGender'.tr();
  static String get stepOneOfSix => 'stepOneOfSix'.tr();
  static String registerStep(int step) => 'registerStep'.tr(args: ['$step']);
  static String get personalizedPlanSubtitle => 'personalizedPlanSubtitle'.tr();
  static String get howOldAreYou => 'howOldAreYou'.tr();
  static String get whatIsYourWeight => 'whatIsYourWeight'.tr();
  static String get whatIsYourHeight => 'whatIsYourHeight'.tr();
  static String get whatIsYourGoal => 'whatIsYourGoal'.tr();
  static String get regularPhysicalActivity => 'regularPhysicalActivity'.tr();
  static String get year => 'year'.tr();
  static String get kilogram => 'kilogram'.tr();
  static String get centimeter => 'centimeter'.tr();
  static String get done => 'done'.tr();
  static String get incompleteRegistrationData =>
      'incompleteRegistrationData'.tr();

  // Forget password flow
  static String get enterYourEmailLabel => 'enterYourEmailLabel'.tr();
  static String get forgetPasswordTitle => 'forgetPasswordTitle'.tr();
  static String get sendOtp => 'sendOtp'.tr();
  static String get otpCodeLabel => 'otpCodeLabel'.tr();
  static String get enterYourOtpCheckYourEmail =>
      'enterYourOtpCheckYourEmail'.tr();
  static String get resendCode => 'resendCode'.tr();
  static String get makeSure8CharsOrMore => 'makeSure8CharsOrMore'.tr();
  static String get createNewPasswordTitle => 'createNewPasswordTitle'.tr();
  static String get doneButton => 'doneButton'.tr();
  static String get passwordChangedSuccessfully =>
      'passwordChangedSuccessfully'.tr();

  // UpcomingWorkouts
  static String get fullBody => 'fullBody'.tr();
  static String get noWorkoutsFound => 'noWorkoutsFound'.tr();
  static String get exercises => 'exercises'.tr();

  // Profile screen
  static String get language => 'language'.tr();
  static String get english => 'English'.tr();
  static String get arabic => 'Arabic'.tr();
  static String get couldNotLaunchLink => 'couldNotLaunchLink'.tr();
  static String get noProfileDataAvailable => 'noProfileDataAvailable'.tr();
  static String get editProfile => 'editProfile'.tr();
  static String get changePassword => 'changePassword'.tr();
  static String get security => 'security'.tr();
  static String get privacyPolicy => 'privacyPolicy'.tr();
  static String get help => 'help'.tr();
  static String get logout => 'logout'.tr();

  // Webviews URLs
  static const String securityUrl =
      'https://elevate-flutter-team.github.io/fitness-app-webviews/security.html';
  static const String privacyPolicyUrl =
      'https://elevate-flutter-team.github.io/fitness-app-webviews/privacy-policy.html';
  static const String helpUrl =
      'https://elevate-flutter-team.github.io/fitness-app-webviews/help.html';
}
