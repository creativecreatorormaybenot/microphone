import 'package:microphone_platform_interface/messages.dart';
import 'package:microphone_platform_interface/microphone_platform_interface.dart';

/// Method channel implementation of the [MicrophonePlatformInterface].
class MethodChannelMicrophone extends MicrophonePlatformInterface {
  final _api = MicrophoneApi();

  @override
  Future<int> create() async {
    final message = await _api.create();

    return message.recorderId!;
  }

  @override
  Future<void> start(int recorderId) async {
    await _api.start(IdMessage()..recorderId = recorderId);
  }

  @override
  Future<String> stop(int recorderId) async {
    final message = await _api.stop(IdMessage()..recorderId = recorderId);

    return message.url!;
  }

  @override
  Future<void> dispose(int recorderId) async {
    await _api.dispose(IdMessage()..recorderId = recorderId);
  }
}
