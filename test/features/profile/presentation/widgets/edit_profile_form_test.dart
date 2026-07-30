import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/values/app_strings.dart';
import 'package:fitness_app/core/values/register_constants.dart';
import 'package:fitness_app/features/profile/presentation/widgets/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('renders profile values and dispatches edit and save actions', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final firstName = TextEditingController(text: 'First');
    final lastName = TextEditingController(text: 'Last');
    final email = TextEditingController(text: 'first@example.com');
    EditProfileField? editedField;
    var saved = false;

    addTearDown(() {
      firstName.dispose();
      lastName.dispose();
      email.dispose();
    });

    await tester.pumpWidget(
      _localizedApp(
        Scaffold(
          body: EditProfileForm(
            formKey: formKey,
            firstNameController: firstName,
            lastNameController: lastName,
            emailController: email,
            userName: 'First Last',
            imageUrl: '',
            localPhotoPath: null,
            weight: 70,
            goal: FitnessGoal.gainWeight,
            activityLevel: ActivityLevel.level1,
            isSubmitting: false,
            isUploadingPhoto: false,
            onPickPhoto: () {},
            onEditField: (field) => editedField = field,
            onSubmit: () => saved = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('First Last'), findsOneWidget);
    expect(find.text('70 ${AppStrings.kilogram}'), findsOneWidget);
    expect(find.text(AppStrings.goalGainWeight), findsOneWidget);
    expect(find.text(AppStrings.activityLevelRookie), findsOneWidget);

    await tester.ensureVisible(find.text(AppStrings.goalGainWeight));
    await tester.tap(find.text(AppStrings.goalGainWeight));
    expect(editedField, EditProfileField.goal);

    await tester.ensureVisible(find.text(AppStrings.saveChanges));
    await tester.tap(find.text(AppStrings.saveChanges));
    expect(saved, isTrue);
    expect(tester.takeException(), isNull);
  });
}

Widget _localizedApp(Widget home) {
  return EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('en'),
    saveLocale: false,
    child: Builder(
      builder: (context) => MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: AppTheme.lightTheme,
        home: home,
      ),
    ),
  );
}
