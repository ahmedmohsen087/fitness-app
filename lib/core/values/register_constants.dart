enum Gender {
  male('male'),
  female('female');

  final String apiValue;

  const Gender(this.apiValue);
}

enum FitnessGoal {
  gainWeight('Gain weight'),
  loseWeight('Lose weight'),
  getFitter('Get fitter'),
  gainMoreFlexible('Gain more flexible'),
  learnTheBasic('Learn the basic');

  final String apiValue;

  const FitnessGoal(this.apiValue);
}

enum ActivityLevel {
  level1('level1'),
  level2('level2'),
  level3('level3'),
  level4('level4'),
  level5('level5');

  final String apiValue;

  const ActivityLevel(this.apiValue);
}

abstract class RegisterConstants {
  static const int minimumAge = 14;
  static const int maximumAge = 100;
  static const int defaultAge = 25;
  static const int minimumWeight = 30;
  static const int maximumWeight = 200;
  static const int defaultWeight = 90;
  static const int minimumHeight = 100;
  static const int maximumHeight = 250;
  static const int defaultHeight = 167;
}
