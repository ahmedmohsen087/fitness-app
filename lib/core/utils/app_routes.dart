import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/screens/activity_selection_screen.dart';
import '../../features/auth/presentation/screens/age_selection_screen.dart';
import '../../features/auth/presentation/screens/gender_selection_screen.dart';
import '../../features/auth/presentation/screens/goal_selection_screen.dart';
import '../../features/auth/presentation/screens/height_selection_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/weight_selection_screen.dart';
import '../../features/auth/presentation/view_model/register_view_model.dart';
import '../../config/di/di.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/view_models/login_view_model.dart';
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
      case AppRoutsName.genderSelection:
        return _registerFlowRoute(
          settings,
          (viewModel) => GenderSelectionScreen(viewModel: viewModel),
        );
      case AppRoutsName.registerAge:
        return _registerFlowRoute(
          settings,
          (viewModel) => AgeSelectionScreen(viewModel: viewModel),
        );

      case AppRoutsName.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<LoginViewModel>(
            create: (_) => getIt<LoginViewModel>(),
            child: const LoginScreen(),
          ),
        );


      case AppRoutsName.registerWeight:
        return _registerFlowRoute(
          settings,
          (viewModel) => WeightSelectionScreen(viewModel: viewModel),
        );
      case AppRoutsName.registerHeight:
        return _registerFlowRoute(
          settings,
          (viewModel) => HeightSelectionScreen(viewModel: viewModel),
        );
      case AppRoutsName.registerGoal:
        return _registerFlowRoute(
          settings,
          (viewModel) => GoalSelectionScreen(viewModel: viewModel),
        );
      case AppRoutsName.registerActivity:
        return _registerFlowRoute(
          settings,
          (viewModel) => ActivitySelectionScreen(viewModel: viewModel),
        );

      default:
        return _notFoundRoute();
    }
  }

  static Route<dynamic> _registerFlowRoute(
    RouteSettings settings,
    Widget Function(RegisterViewModel viewModel) builder,
  ) {
    final argument = settings.arguments;
    if (argument is! RegisterViewModel) return _notFoundRoute();
    return MaterialPageRoute(builder: (_) => builder(argument));
  }

  static Route<dynamic> _notFoundRoute() => MaterialPageRoute(
    builder: (_) =>
        Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
  );
}
