// ignore: import_of_legacy_library_into_null_safe
import 'package:pigeon/dart_generator.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pigeon/pigeon.dart';

class IdMessage {
  int? recorderId;
}

class RecordingMessage {
  String? url;
}

@HostApi(dartHostTestHandler: 'TestMicrophoneApi')
abstract class MicrophoneApi {
  IdMessage create();

  void start(IdMessage message);

  RecordingMessage stop(IdMessage message);

  void dispose(IdMessage message);
}

void configurePigeon(PigeonOptions options) {
  options
    ..dartOut = '../microphone_platform_interface/lib/messages.dart'
    ..dartTestOut = '../microphone_platform_interface/lib/test_api.dart'
    ..dartOptions = (DartOptions()..isNullSafe = true);
}
