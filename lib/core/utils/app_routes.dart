import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/reusable_widgets/app_toast.dart';
import 'package:fitness_app/core/utils/error/error_handler.dart';
import 'package:fitness_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:fitness_app/features/fitness/presentation/screens/exercise_screen.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_events.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
import 'package:fitness_app/features/profile/domain/entities/profile_response_entity.dart';
import 'package:fitness_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:fitness_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_events.dart';
import 'package:fitness_app/features/profile/presentation/view_models/profile_view_models/profile_view_model.dart';
import 'package:fitness_app/features/section_app/upcoming_workouts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/view_models/login_view_model.dart';
import '../../features/food/presentation/screens/food_details_screen.dart';
import '../../features/food/presentation/screens/food_screen.dart';
import '../../features/home/presentation/view_models/home_events.dart';
import '../../features/home/presentation/view_models/home_view_models.dart';
import '../../features/on_boarding/presentation/screens/on_boarding.dart';
import '../../features/section_app/section_app.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../values/app_routs_name.dart';
import '../values/app_strings.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case AppRoutsName.splashScreen:
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const SplashScreen(),
          );
        case AppRoutsName.onBoarding:
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const OnBoarding(),
          );

        case AppRoutsName.sectionApp:
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider(
              create: (_) =>
                  getIt<HomeViewModel>()..doEvent(LoadHomeDataEvent()),
              child: const SectionApp(),
            ),
          );
        case AppRoutsName.register:
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const RegisterScreen(),
          );
        case AppRoutsName.loginScreen:
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider<LoginViewModel>(
              create: (_) => getIt<LoginViewModel>(),
              child: const LoginScreen(),
            ),
          );
        case AppRoutsName.forgetPasswordScreen:
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider(
              create: (_) => getIt<ForgetPasswordViewModel>(),
              child: const ForgetPasswordScreen(),
            ),
          );

        case AppRoutsName.emailVerificationScreen:
          final viewModel = settings.arguments as ForgetPasswordViewModel;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider.value(
              value: viewModel,
              child: const EmailVerificationScreen(),
            ),
          );

        case AppRoutsName.resetPassword:
          final viewModel = settings.arguments as ForgetPasswordViewModel;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider.value(
              value: viewModel,
              child: const ResetPasswordScreen(),
            ),
          );
        case AppRoutsName.food:
          final initialCategory =
              settings.arguments is String &&
                  (settings.arguments! as String).trim().isNotEmpty
              ? settings.arguments! as String
              : null;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => FoodScreen(initialCategory: initialCategory),
          );
        case AppRoutsName.foodDetails:
          final mealId = settings.arguments is String
              ? (settings.arguments! as String).trim()
              : '';
          if (mealId.isEmpty) return _notFoundRoute(settings);
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => FoodDetailsScreen(mealId: mealId),
          );
        case AppRoutsName.upcomingWorkout:
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider<FitnessViewModel>(
              create: (_) =>
                  getIt<FitnessViewModel>()
                    ..doEvent(LoadHomeFitnessDataEvent()),
              child: const UpcomingWorkoutsScreen(),
            ),
          );
        case AppRoutsName.exercise:
          final args = settings.arguments;
          if (args is ExerciseScreenArgs) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => ExerciseScreen(args: args),
            );
          } else if (args is String && args.isNotEmpty) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => ExerciseScreen(
                args: ExerciseScreenArgs(
                  primeMoverMuscleId: args,
                  muscleName: '',
                  image: '',
                ),
              ),
            );
          }
          return _notFoundRoute(settings);
        case AppRoutsName.profileScreen:
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider(
              create: (_) =>
                  getIt<GetProfileViewModel>()
                    ..doEvent(const RefreshProfileEvent()),
              child: const ProfileScreen(),
            ),
          );
        case AppRoutsName.editProfileScreen:
          final profile = settings.arguments;
          if (profile is! ProfileResponseEntity) {
            return _notFoundRoute(settings);
          }
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => EditProfileScreen(profile: profile),
          );
        default:
          return _notFoundRoute(settings);
      }
    } catch (e) {
      debugPrint("Routing Exception caught: $e");

      final errorMessage = ErrorHandler.handle(e);

      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppToast.error(context, errorMessage, position: ToastPosition.top);
          });

          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: SizedBox.shrink(),
          );
        },
      );
    }
  }

  static Route<dynamic> _notFoundRoute(RouteSettings settings) =>
      MaterialPageRoute(
        settings: settings,
        builder: (_) =>
            Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
      );
}
