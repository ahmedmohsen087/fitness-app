import 'package:fitness_app/config/di/di.dart';
import 'package:fitness_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      case AppRoutsName.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ForgetPasswordViewModel>(),
            child: const ForgetPasswordScreen(),
          ),
        );

      case AppRoutsName.emailVerificationScreen:
        final viewModel = settings.arguments as ForgetPasswordViewModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: viewModel,
            child: const EmailVerificationScreen(),
          ),
        );

      case AppRoutsName.resetPassword:
        final viewModel = settings.arguments as ForgetPasswordViewModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: viewModel,
            child: const ResetPasswordScreen(),
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
