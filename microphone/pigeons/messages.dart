import 'package:pigeon/pigeon.dart';

class IdMessage {
  int recorderId;
}

class RecordingMessage {
  String url;
}

@HostApi(dartHostTestHandler: 'TestMicrophoneApi')
abstract class MicrophoneApi {
  IdMessage create();
  void start(IdMessage message);
  RecordingMessage stop(IdMessage message);
  void dispose(IdMessage message);
}

void configurePigeon(PigeonOptions options) {
  options.dartOut = '../microphone_platform_interface/lib/messages.dart';
}
