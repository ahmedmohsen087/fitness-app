import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di/di.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/app_strings.dart';
import '../view_model/register_events.dart';
import '../view_model/register_view_model.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_glass_panel.dart';
import '../widgets/auth_logo.dart';
import '../widgets/register_flow_listener.dart';
import '../widgets/register_form.dart';
import 'activity_selection_screen.dart';
import 'age_selection_screen.dart';
import 'gender_selection_screen.dart';
import 'goal_selection_screen.dart';
import 'height_selection_screen.dart';
import 'weight_selection_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterViewModel>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pageController = PageController();
  bool _obscurePassword = true;
  int _currentPage = 0;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _continueToGender() {
    if (!_formKey.currentState!.validate()) return;
    context.read<RegisterViewModel>().doEvent(
      ContinueToGenderEvent(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rePassword: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RegisterFlowListener(
      pageController: _pageController,
      child: PopScope(
        canPop: _currentPage == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _previousPage();
        },
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) => setState(() => _currentPage = page),
          children: [
            _registerDetailsPage(),
            GenderSelectionScreen(onBack: _previousPage),
            AgeSelectionScreen(onBack: _previousPage),
            WeightSelectionScreen(onBack: _previousPage),
            HeightSelectionScreen(onBack: _previousPage),
            GoalSelectionScreen(onBack: _previousPage),
            ActivitySelectionScreen(onBack: _previousPage),
          ],
        ),
      ),
    );
  }

  Widget _registerDetailsPage() {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const AuthLogo(),
                    const SizedBox(height: 39),
                    const _RegisterHeader(),
                    const SizedBox(height: 8),
                    AuthGlassPanel(
                      child: RegisterForm(
                        formKey: _formKey,
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        onTogglePassword: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        onRegister: _continueToGender,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _previousPage() {
    if (_currentPage == 0 || !_pageController.hasClients) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.heyThere, style: TextStyles.authGreeting),
            Text(AppStrings.createAnAccount, style: TextStyles.authHeadline),
          ],
        ),
      ),
    );
  }
}
