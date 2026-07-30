import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/core/reusable_widgets/app_toast.dart';
import 'package:fitness_app/core/utils/error/error_handler.dart';
import 'package:fitness_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_events.dart';
import 'package:fitness_app/features/fitness/presentation/view_model/fitness_view_model.dart';
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
      final route = _matchRoute(settings);
      return route ?? _notFoundRoute(settings);
    } catch (e) {
      return _handleRouteError(settings, e);
    }
  }

  static Route<dynamic>? _matchRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutsName.splashScreen:
        return _pageRoute(settings, const SplashScreen());
      case AppRoutsName.onBoarding:
        return _pageRoute(settings, const OnBoarding());
      case AppRoutsName.sectionApp:
        return _buildSectionAppRoute(settings);
      case AppRoutsName.register:
        return _pageRoute(settings, const RegisterScreen());
      case AppRoutsName.loginScreen:
        return _buildLoginRoute(settings);
      case AppRoutsName.forgetPasswordScreen:
        return _buildForgetPasswordRoute(settings);
      case AppRoutsName.emailVerificationScreen:
        return _buildEmailVerificationRoute(settings);
      case AppRoutsName.resetPassword:
        return _buildResetPasswordRoute(settings);
      case AppRoutsName.food:
        return _buildFoodRoute(settings);
      case AppRoutsName.foodDetails:
        return _buildFoodDetailsRoute(settings);
      case AppRoutsName.upcomingWorkout:
        return _buildUpcomingWorkoutRoute(settings);
      default:
        return null;
    }
  }

  static Route<dynamic> _pageRoute(RouteSettings settings, Widget page) {
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }

  static Route<dynamic> _buildSectionAppRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<HomeViewModel>(
            create: (_) => getIt<HomeViewModel>()..doEvent(LoadHomeDataEvent()),
          ),
          BlocProvider<FitnessViewModel>(
            create: (_) => getIt<FitnessViewModel>()
              ..doEvent(LoadHomeFitnessDataEvent()),
          ),
        ],
        child: const SectionApp(),
      ),
    );
  }

  static Route<dynamic> _buildLoginRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => BlocProvider<LoginViewModel>(
        create: (_) => getIt<LoginViewModel>(),
        child: const LoginScreen(),
      ),
    );
  }

  static Route<dynamic> _buildForgetPasswordRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => BlocProvider(
        create: (_) => getIt<ForgetPasswordViewModel>(),
        child: const ForgetPasswordScreen(),
      ),
    );
  }

  static Route<dynamic> _buildEmailVerificationRoute(RouteSettings settings) {
    final viewModel = settings.arguments as ForgetPasswordViewModel;
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => BlocProvider.value(
        value: viewModel,
        child: const EmailVerificationScreen(),
      ),
    );
  }

  static Route<dynamic> _buildResetPasswordRoute(RouteSettings settings) {
    final viewModel = settings.arguments as ForgetPasswordViewModel;
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => BlocProvider.value(
        value: viewModel,
        child: const ResetPasswordScreen(),
      ),
    );
  }

  static Route<dynamic> _buildFoodRoute(RouteSettings settings) {
    final initialCategory = settings.arguments is String &&
            (settings.arguments! as String).trim().isNotEmpty
        ? settings.arguments! as String
        : null;
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => FoodScreen(initialCategory: initialCategory),
    );
  }

  static Route<dynamic> _buildFoodDetailsRoute(RouteSettings settings) {
    final mealId = settings.arguments is String
        ? (settings.arguments! as String).trim()
        : '';
    if (mealId.isEmpty) return _notFoundRoute(settings);
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => FoodDetailsScreen(mealId: mealId),
    );
  }

  static Route<dynamic> _buildUpcomingWorkoutRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => BlocProvider<FitnessViewModel>(
        create: (_) => getIt<FitnessViewModel>()
          ..doEvent(LoadHomeFitnessDataEvent()),
        child: const UpcomingWorkoutsScreen(),
      ),
    );
  }

  static Route<dynamic> _handleRouteError(RouteSettings settings, Object e) {
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

  static Route<dynamic> _notFoundRoute(RouteSettings settings) =>
      MaterialPageRoute(
        settings: settings,
        builder: (_) =>
            Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
      );
}
