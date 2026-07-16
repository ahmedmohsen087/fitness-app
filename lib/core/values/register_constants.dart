abstract class RegisterConstants {
  static const String genderMale = 'male';
  static const String genderFemale = 'female';
  static const Set<String> genders = {genderMale, genderFemale};

  static const int minimumAge = 14;
  static const int maximumAge = 100;
  static const int defaultAge = 25;
  static const int minimumWeight = 30;
  static const int maximumWeight = 200;
  static const int defaultWeight = 90;
  static const int minimumHeight = 100;
  static const int maximumHeight = 250;
  static const int defaultHeight = 167;

  static const String goalGainWeight = 'Gain weight';
  static const String goalLoseWeight = 'Lose weight';
  static const String goalGetFitter = 'Get fitter';
  static const String goalGainMoreFlexible = 'Gain more flexible';
  static const String goalLearnTheBasic = 'Learn the basic';
  static const Set<String> goals = {
    goalGainWeight,
    goalLoseWeight,
    goalGetFitter,
    goalGainMoreFlexible,
    goalLearnTheBasic,
  };

  static const String activityLevel1 = 'level1';
  static const String activityLevel2 = 'level2';
  static const String activityLevel3 = 'level3';
  static const String activityLevel4 = 'level4';
  static const String activityLevel5 = 'level5';
  static const Set<String> activityLevels = {
    activityLevel1,
    activityLevel2,
    activityLevel3,
    activityLevel4,
    activityLevel5,
  };
}
