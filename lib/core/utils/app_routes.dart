
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/di/di.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/view_models/login_view_model.dart';
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
          builder: (_) => const SplashScreen(),
        );
      case AppRoutsName.onBoarding:
        return MaterialPageRoute(
          builder: (_) => const OnBoarding(),
        );

      case AppRoutsName.sectionApp:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<HomeViewModel>()
              ..getRecommendationToDay()..getMusclesGroup()..musclesGroupById,
            child: const SectionApp(),
          ),
        );

      case AppRoutsName.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<LoginViewModel>(
            create: (_) => getIt<LoginViewModel>(),
            child: const LoginScreen(),
          ),
        );



      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
        );
    }
  }
}
