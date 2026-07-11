import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

enum ToastType { success, error, warning, info }

enum ToastPosition { top, bottom, center }

abstract class AppToast {
  const AppToast._();

  static const Duration _defaultDuration = Duration(seconds: 3);

  static void success(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.bottom,
    Duration duration = _defaultDuration,
  }) => _show(context, message, ToastType.success, position, duration);

  static void error(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.bottom,
    Duration duration = _defaultDuration,
  }) => _show(context, message, ToastType.error, position, duration);

  static void warning(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.bottom,
    Duration duration = _defaultDuration,
  }) => _show(context, message, ToastType.warning, position, duration);

  static void info(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.bottom,
    Duration duration = _defaultDuration,
  }) => _show(context, message, ToastType.info, position, duration);

  static void _show(
    BuildContext context,
    String message,
    ToastType type,
    ToastPosition position,
    Duration duration,
  ) {
    if (message.trim().isEmpty) return;

    final fToast = FToast()..init(context);
    fToast.removeQueuedCustomToasts();
    fToast.showToast(
      gravity: _gravityOf(position),
      toastDuration: duration,
      child: _ToastCard(message: message, type: type),
    );
  }

  static ToastGravity _gravityOf(ToastPosition position) => switch (position) {
    ToastPosition.top => ToastGravity.TOP,
    ToastPosition.bottom => ToastGravity.BOTTOM,
    ToastPosition.center => ToastGravity.CENTER,
  };
}

class _ToastCard extends StatelessWidget {
  final String message;
  final ToastType type;

  const _ToastCard({required this.message, required this.type});

  Color get _color => switch (type) {
    ToastType.success => AppColors.success,
    ToastType.error => AppColors.red,
    ToastType.warning => AppColors.warning,
    ToastType.info => AppColors.info,
  };

  IconData get _icon => switch (type) {
    ToastType.success => Icons.check_circle_rounded,
    ToastType.error => Icons.error_rounded,
    ToastType.warning => Icons.warning_amber_rounded,
    ToastType.info => Icons.info_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: .45)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .18),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: TextStyles.bodyRegular14.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
