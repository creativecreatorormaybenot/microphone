import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:http/http.dart' as http;
import 'package:microphone_platform_interface/microphone_platform_interface.dart';

/// The web implementation of the [MicrophonePlatformInterface].
///
/// This class implements the `microphone` plugin functionality for web.
class MicrophoneWeb extends MicrophonePlatformInterface {
  /// Registers [MicrophoneWeb] as the default instance of the
  /// [MicrophonePlatformInterface].
  static void registerWith(Registrar registrar) {
    MicrophonePlatformInterface.instance = MicrophoneWeb();
  }

  final _recorders = <int, _Recorder>{};

  var _recorderCounter = 0;

  @override
  Future<int> create() async {
    final recorderId = ++_recorderCounter;

    final recorder = _Recorder();
    _recorders[recorderId] = recorder;
    await recorder.init();

    return recorderId;
  }

  @override
  Future<void> start(int recorderId) {
    assert(_recorders.containsKey(recorderId));

    return _recorders[recorderId]!.start();
  }

  @override
  Future<String> stop(int recorderId) {
    assert(_recorders.containsKey(recorderId));

    return _recorders[recorderId]!.stop();
  }

  @override
  Future<Uint8List> toBytes(int recorderId) {
    assert(_recorders.containsKey(recorderId));

    return _recorders[recorderId]!.toBytes();
  }

  @override
  Future<void> dispose(int recorderId) async {
    assert(_recorders.containsKey(recorderId));

    _recorders[recorderId]!.dispose();
    _recorders.remove(recorderId);
  }
}

class _Recorder {
  MediaRecorder? _mediaRecorder;
  List<Blob>? _audioBlobParts;
  String? _recordingUrl;

  Future<void> init() async {
    assert(_mediaRecorder == null);

    final stream =
        await window.navigator.getUserMedia(audio: true, video: false);
    _mediaRecorder = MediaRecorder(stream);

    _audioBlobParts = [];
    _mediaRecorder!.addEventListener('dataavailable', _onDataAvailable);
  }

  void _onDataAvailable(Event event) {
    final blobEvent = event as BlobEvent;

    _audioBlobParts!.add(blobEvent.data!);
  }

  Future<void> start() async {
    assert(_mediaRecorder != null);

    _mediaRecorder!.start();
  }

  /// Stops the recorder and returns an URL pointing to the recording.
  Future<String> stop() async {
    assert(_mediaRecorder != null);
    assert(_recordingUrl == null);

    final completer = Completer<String>();

    void onStop(_) {
      assert(_audioBlobParts != null);

      final blob = Blob(_audioBlobParts!);
      _audioBlobParts = null;

      completer.complete(Url.createObjectUrl(blob));
    }

    _mediaRecorder!.addEventListener('stop', onStop);
    _mediaRecorder!.stop();
    _recordingUrl = await completer.future;
    _mediaRecorder!.removeEventListener('stop', onStop);

    return _recordingUrl!;
  }

  Future<Uint8List> toBytes() async {
    assert(_recordingUrl != null);

    final result = await http.get(Uri.parse(_recordingUrl!));
    return result.bodyBytes;
  }

  void dispose() {
    assert(_mediaRecorder != null);

    _mediaRecorder!.removeEventListener('dataavailable', _onDataAvailable);
    _mediaRecorder = null;
  }
}
