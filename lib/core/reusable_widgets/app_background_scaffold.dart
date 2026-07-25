import 'dart:ui';
import 'package:flutter/material.dart';

class AppBackgroundScaffold extends StatelessWidget {
  final String imagePath;
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool resizeToAvoidBottomInset;
  final double blurSigmaX;
  final double blurSigmaY;
  final double overlayOpacity;

  const AppBackgroundScaffold({
    super.key,
    required this.imagePath,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.blurSigmaX = 15.0,
    this.blurSigmaY = 15.0,
    this.overlayOpacity = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: const Color(0xFF181818)),
          ),
        ),

        // Blur & Overlay Effect (Frosted Glass)
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurSigmaX,
              sigmaY: blurSigmaY,
            ),
            child: Container(
              color: Colors.black.withValues(alpha: overlayOpacity),
            ),
          ),
        ),

        // Scaffold Content
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          appBar: appBar,
          body: SafeArea(child: child),
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
        ),
      ],
    );
  }
}
