import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:microphone_platform_interface/messages.dart';
import 'package:microphone_platform_interface/method_channel_microphone.dart';
import 'package:microphone_platform_interface/microphone_platform_interface.dart';

class _ApiLogger implements TestMicrophoneApi {
  final List<String> log = [];
  IdMessage idMessage;

  @override
  IdMessage create() {
    log.add('create');
    return IdMessage()..recorderId = 0;
  }

  @override
  void start(IdMessage message) {
    log.add('start');
    idMessage = message;
  }

  @override
  RecordingMessage stop(IdMessage message) {
    log.add('stop');
    idMessage = message;
    return RecordingMessage()..url = 'test';
  }

  @override
  void dispose(IdMessage message) {
    log.add('dispose');
    idMessage = message;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MicrophonePlatformInterface', () {
    test('$MethodChannelMicrophone() is the default instance', () {
      expect(MicrophonePlatformInterface.instance,
          isInstanceOf<MethodChannelMicrophone>());
    });

    test('Cannot be implemented with `implements`', () {
      expect(() {
        MicrophonePlatformInterface.instance =
            ImplementsMicrophonePlatformInterface();
      }, throwsA(isInstanceOf<AssertionError>()));
    });

    test('Can be mocked with `implements`', () {
      final mock = ImplementsMicrophonePlatformInterface();
      when(mock.isMock).thenReturn(true);
      MicrophonePlatformInterface.instance = mock;
    });

    test('Can be extended', () {
      MicrophonePlatformInterface.instance = ExtendsVideoPlayerPlatform();
    });
  });

  group('$MethodChannelMicrophone', () {
    final microphone = MethodChannelMicrophone();
    _ApiLogger logger;

    setUp(() {
      logger = _ApiLogger();
      TestMicrophoneApi.setup(logger);
    });

    test('create', () async {
      final recorderId = await microphone.create();

      expect(logger.log.last, 'create');
      expect(recorderId, 0);
    });

    test('start', () async {
      await microphone.start(1);

      expect(logger.log.last, 'start');
      expect(logger.idMessage.recorderId, 1);
    });

    test('stop', () async {
      final recording = await microphone.stop(2);

      expect(logger.log.last, 'stop');
      expect(logger.idMessage.recorderId, 2);
      expect(recording, 'test');
    });
    test('dispose', () async {
      await microphone.dispose(42);

      expect(logger.log.last, 'dispose');
      expect(logger.idMessage.recorderId, 42);
    });
  });
}

class ImplementsMicrophonePlatformInterface extends Mock
    implements MicrophonePlatformInterface {}

class ExtendsVideoPlayerPlatform extends MicrophonePlatformInterface {}
