import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/on_boarding/presentation/screens/on_boarding.dart';
import '../../features/section_app/section_app.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../values/app_routs_name.dart';
import '../values/app_strings.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutsName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutsName.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoarding());
      case AppRoutsName.sectionApp:
        return MaterialPageRoute(builder: (_) => const SectionApp());
      case AppRoutsName.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      default:
        return _notFoundRoute();
    }
  }

  static Route<dynamic> _notFoundRoute() => MaterialPageRoute(
    builder: (_) =>
        Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
  );
}
