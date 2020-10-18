import 'package:flutter_test/flutter_test.dart';
import 'package:microphone_platform_interface/microphone_platform_interface.dart';
import 'package:microphone_web/microphone_web.dart';

@TestOn('browser')
void main() {
  group('$MicrophoneWeb', () {
    setUpAll(() async {
      // todo: the web tests do not work as the JS library import does not work.
      MicrophonePlatformInterface.instance = MicrophoneWeb();
    });

    test('$MicrophoneWeb set as default instance', () {
      expect(MicrophonePlatformInterface.instance, isA<MicrophoneWeb>());
    });
  });
}
