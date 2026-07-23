import 'package:flutter/widgets.dart';

class RecordingNavigatorObserver extends NavigatorObserver {
  final List<String> pushedRoutes = [];
  final List<Object?> pushedArguments = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = route.settings.name;
    if (name != null) {
      pushedRoutes.add(name);
      pushedArguments.add(route.settings.arguments);
    }
    super.didPush(route, previousRoute);
  }
}
