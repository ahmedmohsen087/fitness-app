import 'package:easy_localization/easy_localization.dart';

abstract class AppStrings {
  // Routes & General
  static String get routeNotFound => 'routeNotFound'.tr();
  static String get home => 'home'.tr();
  static String get workouts => 'workouts'.tr();
  static String get profile => 'profile'.tr();
  static String get chat => 'chat'.tr();

  static String get next => 'next'.tr();
  static String get back => 'back'.tr();
  static String get getStarted => 'getStarted'.tr();
  static String get skip => 'skip'.tr();

  static String get thePriceOfExcellenceIsDiscipline =>
      'ThePriceOfExcellenceIsDiscipline'.tr();
  static String get fitnessHasNeverBeenSoMuchFun =>
      'fitnessHasNeverBeenSoMuchFun'.tr();
  static String get noMoreExcusesDoItNow => 'NoMoreExcusesDoItNow'.tr();
  static String get onBoardingDescription => 'onBoardingDescription'.tr();

  // Storage / Session Keys
  static String get tokenEmpty => 'tokenEmpty'.tr();
  static String get tokenWriteFailed => 'tokenWriteFailed'.tr();
  static String get tokenReadFailed => 'tokenReadFailed'.tr();
  static String get tokenDeleteFailed => 'tokenDeleteFailed'.tr();

  static String get rememberMeWriteFailed => 'rememberMeWriteFailed'.tr();
  static String get rememberMeReadFailed => 'rememberMeReadFailed'.tr();
  static String get rememberMeDeleteFailed => 'rememberMeDeleteFailed'.tr();

  static String get seenOnboardingWriteFailed =>
      'seenOnboardingWriteFailed'.tr();
  static String get seenOnboardingReadFailed =>
      'seenOnboardingReadFailed'.tr();

  static String get clearStorageFailed => 'clearStorageFailed'.tr();

  // Validation
  static String get firstNameRequired => 'firstNameRequired'.tr();
  static String get lastNameRequired => 'lastNameRequired'.tr();
  static String get nameInvalid => 'nameInvalid'.tr();
  static String get nameTooShort => 'nameTooShort'.tr();
  static String get nameTooLong => 'nameTooLong'.tr();

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

  static String get phoneRequired => 'phoneRequired'.tr();
  static String get phoneInvalid => 'phoneInvalid'.tr();

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

  static String get otpEmpty => 'otpEmpty'.tr();
  static String get otpInvalid => 'otpInvalid'.tr();
  static String get otpLength => 'otpLength'.tr();

  // API Errors
  static String get noInternetConnection => 'noInternetConnection'.tr();
  static String get connectionTimeout => 'connectionTimeout'.tr();
  static String get requestCancelled => 'requestCancelled'.tr();
  static String get badCertificate => 'badCertificate'.tr();
  static String get somethingWentWrong => 'somethingWentWrong'.tr();

  // Gender & User Attributes
  static String get idNumber => 'idNumber'.tr();
  static String get male => 'male'.tr();
  static String get female => 'female'.tr();

  // Goals
  static String get goalGainWeight => 'goalGainWeight'.tr();
  static String get goalLoseWeight => 'goalLoseWeight'.tr();
  static String get goalGetFitter => 'goalGetFitter'.tr();
  static String get goalGainMoreFlexible => 'goalGainMoreFlexible'.tr();
  static String get goalLearnTheBasic => 'goalLearnTheBasic'.tr();

  // Activity Levels
  static String get activityLevelRookie => 'activityLevelRookie'.tr();
  static String get activityLevelBeginner => 'activityLevelBeginner'.tr();
  static String get activityLevelIntermediate =>
      'activityLevelIntermediate'.tr();
  static String get activityLevelAdvance => 'activityLevelAdvance'.tr();
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
  static String get personalizedPlanSubtitle =>
      'personalizedPlanSubtitle'.tr();
  static String get howOldAreYou => 'howOldAreYou'.tr();
  static String get whatIsYourWeight => 'whatIsYourWeight'.tr();
  static String get whatIsYourHeight => 'whatIsYourHeight'.tr();
  static String get whatIsYourGoal => 'whatIsYourGoal'.tr();
  static String get regularPhysicalActivity =>
      'regularPhysicalActivity'.tr();
  static String get year => 'year'.tr();
  static String get kilogram => 'kilogram'.tr();
  static String get centimeter => 'centimeter'.tr();
  static String get done => 'done'.tr();
  static String get incompleteRegistrationData =>
      'incompleteRegistrationData'.tr();
  static String get idNumberRequired => 'idNumberRequired'.tr();

  // Login
  static String get heyThere => 'heyThere'.tr();
  static String get welcomeBACK => 'welcomeBACK'.tr();
  static String get login => 'login'.tr();
  static String get don'tHaveAnAccountYet => 'don\'tHaveAnAccountYet'.tr();
  static String get register => 'register'.tr();
  static String get or => 'or'.tr();
  static String get rememberMe => 'rememberMe'.tr();
  static String get loggedInSuccessfully => 'loggedInSuccessfully'.tr();

  // Categories
  static String get gym => 'gym'.tr();
  static String get trainer => 'trainer'.tr();
  static String get fitness => 'fitness'.tr();
  static String get aerobics => 'aerobics'.tr();
  static String get yoga => 'yoga'.tr();
  static String get category => 'category'.tr();

  // Home
  static String get hi => 'hi'.tr();
  static String get letsStartYourDay => 'letsStartYourDay'.tr();
  static String get recommendationToDay => 'recommendationToDay'.tr();
  static String get upcomingWorkouts => 'upcomingWorkouts'.tr();
  static String get recommendationForYou => 'recommendationForYou'.tr();
  static String get popularTraining => 'popularTraining'.tr();
  static String get seeAll => 'seeAll'.tr();

  // Food
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
  static String get selectLanguage => 'selectLanguage'.tr();
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
  static String get areYouSureYouWantToLogout =>
      'areYouSureYouWantToLogout'.tr();
  static String get no => 'no'.tr();
  static String get yes => 'yes'.tr();
  static String get oldPassword => 'oldPassword'.tr();
  static String get pleaseEnterOldPassword => 'pleaseEnterOldPassword'.tr();
  static String get passwordMustBeAtLeast8Chars =>
      'passwordMustBeAtLeast8Chars'.tr();
  static String get passwordsDoNotMatch => 'passwordsDoNotMatch'.tr();
  static String get success => 'success'.tr();
  static String get smartCoach => 'smartCoach'.tr();
  static String get iAmYourSmartCoach => 'iAmYourSmartCoach'.tr();
  static String get howCanIAssistYouToday => 'howCanIAssistYouToday'.tr();
  static String get previousConversations => 'previousConversations'.tr();
  static String get newChat => 'newChat'.tr();
  static String get typeYourMessage => 'typeYourMessage'.tr();
  static String get goToDetails => 'goToDetails'.tr();
  static String get chooseImageSource => 'chooseImageSource'.tr();
  static String get camera => 'camera'.tr();
  static String get gallery => 'gallery'.tr();

  // Edit Profile UI Strings
  static String get saveChanges => 'saveChanges'.tr();
  static String get profileUpdatedSuccessfully =>
      'profileUpdatedSuccessfully'.tr();
  static String get profilePhotoUpdatedSuccessfully =>
      'profilePhotoUpdatedSuccessfully'.tr();
  static String get selectProfilePhoto => 'selectProfilePhoto'.tr();
  static String get profilePhotoTooLarge => 'profilePhotoTooLarge'.tr();
  static String get profilePhotoCompressionFailed =>
      'profilePhotoCompressionFailed'.tr();
  static String get yourWeight => 'yourWeight'.tr();
  static String get yourGoal => 'yourGoal'.tr();
  static String get yourActivityLevel => 'yourActivityLevel'.tr();
  static String get tapToEdit => 'tapToEdit'.tr();
  static String get incompleteProfileData => 'incompleteProfileData'.tr();

  // Webviews URLs
  static const String securityUrl =
      'https://elevate-flutter-team.github.io/fitness-app-webviews/security.html';
  static const String privacyPolicyUrl =
      'https://elevate-flutter-team.github.io/fitness-app-webviews/privacy-policy.html';
  static const String helpUrl =
      'https://elevate-flutter-team.github.io/fitness-app-webviews/help.html';
}
