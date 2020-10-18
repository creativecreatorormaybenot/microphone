import 'package:flutter_test/flutter_test.dart';
import 'package:microphone/microphone.dart';
import 'package:microphone_platform_interface/messages.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MicrophoneRecorder', () {
    FakeMicrophoneApi fakeMicrophone;
    MicrophoneRecorder recorder;

    setUpAll(() {
      fakeMicrophone = FakeMicrophoneApi();
    });

    test('can create recorder', () {
      expect(() => recorder = MicrophoneRecorder()..init(), returnsNormally);

      expect(fakeMicrophone.calls, hasLength(1));
      expect(fakeMicrophone.calls.last, 'create');
    });

    test('start', () {
      // Cannot stop before starting.
      expect(recorder.stop, throwsAssertionError);
      expect(fakeMicrophone.calls.last, 'create');

      expect(recorder.start, returnsNormally);
      expect(fakeMicrophone.calls.last, 'start');
    });

    test('can only start once', () {
      expect(recorder.start, throwsAssertionError);
    });

    test('stop', () {
      expect(recorder.stop, returnsNormally);
      expect(fakeMicrophone.calls.last, 'stop');
    });

    test('cannot stop twice', () {
      expect(recorder.stop, throwsAssertionError);
    });

    test('dispose', () {
      // Cannot init twice.
      expect(recorder.init, throwsAssertionError);
      expect(fakeMicrophone.calls.last, 'stop');

      expect(recorder.dispose, returnsNormally);
      expect(fakeMicrophone.calls.last, 'dispose');

      // Cannot dispose twice.
      expect(recorder.dispose, throwsAssertionError);

      // Cannot init again.
      expect(recorder.init, throwsAssertionError);

      // Cannot use any method after disposing.
      expect(recorder.start, throwsAssertionError);
      expect(recorder.stop, throwsAssertionError);

      expect(fakeMicrophone.calls.last, 'dispose');
    });
  });
}

class FakeMicrophoneApi extends TestMicrophoneApi {
  FakeMicrophoneApi() {
    TestMicrophoneApi.setup(this);
  }

  final calls = <String>[];

  @override
  IdMessage create() {
    calls.add('create');
    return IdMessage()..recorderId = -1;
  }

  @override
  void dispose(IdMessage message) {
    calls.add('dispose');
  }

  @override
  void start(IdMessage message) {
    calls.add('start');
  }

  @override
  RecordingMessage stop(IdMessage message) {
    calls.add('stop');
    return RecordingMessage()..url = 'test';
  }
}
