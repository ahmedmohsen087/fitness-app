import 'package:fitness_app/core/reusable_widgets/app_video_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('extracts IDs from supported YouTube URLs', () {
    expect(
      YoutubeVideoIdParser.parse('https://www.youtube.com/watch?v=xvPR2Tfw5k0'),
      'xvPR2Tfw5k0',
    );
    expect(
      YoutubeVideoIdParser.parse('https://youtu.be/xvPR2Tfw5k0'),
      'xvPR2Tfw5k0',
    );
    expect(
      YoutubeVideoIdParser.parse('https://youtube.com/embed/xvPR2Tfw5k0'),
      'xvPR2Tfw5k0',
    );
  });

  test('rejects invalid video URLs', () {
    expect(YoutubeVideoIdParser.parse('not a URL'), isNull);
    expect(YoutubeVideoIdParser.parse('https://example.com/video'), isNull);
  });
}
