import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/di/di.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/view_models/login_view_model.dart';
import '../../features/home/presentation/screens/food_details_screen.dart';
import '../../features/home/presentation/screens/food_screen.dart';
import '../../features/home/presentation/view_models/home_events.dart';
import '../../features/home/presentation/view_models/home_view_models.dart';
import '../../features/on_boarding/presentation/screens/on_boarding.dart';
import '../../features/section_app/section_app.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../values/app_routs_name.dart';
import '../values/app_strings.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
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
        final initialTabIndex = settings.arguments is int
            ? settings.arguments! as int
            : 0;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<HomeViewModel>()..doEvent(LoadHomeDataEvent()),
            child: SectionApp(initialTabIndex: initialTabIndex),
          ),
          settings: settings,
          // builder: (_) => const SectionApp(),
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
      default:
        return _notFoundRoute(settings);
    }
  }

  static Route<dynamic> _notFoundRoute(RouteSettings settings) =>
      MaterialPageRoute(
        settings: settings,
        builder: (_) =>
            Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
      );
}
