import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../values/app_strings.dart';

abstract class AppVideoDialog {
  static Future<void> show(
    BuildContext context, {
    required String youtubeUrl,
    required String title,
  }) async {
    final videoId = YoutubeVideoIdParser.parse(youtubeUrl);
    if (videoId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.videoUnavailable)));
      return;
    }

    await showDialog<void>(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.82),
      builder: (_) => _VideoDialog(videoId: videoId, title: title),
    );
  }
}

abstract class YoutubeVideoIdParser {
  static String? parse(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null || uri.host.isEmpty) return null;

    final host = uri.host.toLowerCase().replaceFirst('www.', '');
    String? id;
    if (host == 'youtu.be') {
      id = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
    } else if (host == 'youtube.com' || host == 'm.youtube.com') {
      id = uri.queryParameters['v'];
      if ((id == null || id.isEmpty) && uri.pathSegments.length >= 2) {
        const supportedPaths = {'embed', 'shorts', 'live'};
        if (supportedPaths.contains(uri.pathSegments.first)) {
          id = uri.pathSegments[1];
        }
      }
    }

    final normalized = id?.trim();
    if (normalized == null ||
        !RegExp(r'^[a-zA-Z0-9_-]{6,}$').hasMatch(normalized)) {
      return null;
    }
    return normalized;
  }
}

class _VideoDialog extends StatefulWidget {
  final String videoId;
  final String title;

  const _VideoDialog({required this.videoId, required this.title});

  @override
  State<_VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<_VideoDialog> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: AppColors.lightBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.authHeadline,
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: AppStrings.close,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
          ],
        ),
      ),
    );
  }
}
