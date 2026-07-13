import 'package:fitness_app/core/values/app_routs_name.dart';
import 'package:fitness_app/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:fitness_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutsName.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<ForgetPasswordViewModel>(context),
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
        return null;
    }
  }
}
