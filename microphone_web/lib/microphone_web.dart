import 'dart:async';
import 'dart:html';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
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

    return _recorders[recorderId].start();
  }

  @override
  Future<String> stop(int recorderId) {
    assert(_recorders.containsKey(recorderId));

    return _recorders[recorderId].stop();
  }

  @override
  Future<void> dispose(int recorderId) async {
    assert(_recorders.containsKey(recorderId));

    await _recorders[recorderId].dispose();
    _recorders.remove(recorderId);
  }
}

class _Recorder {
  MediaRecorder _mediaRecorder;
  List<Blob> _audioBlobParts;

  Future<void> init() async {
    assert(_mediaRecorder == null);

    final stream =
        await window.navigator.getUserMedia(audio: true, video: false);
    _mediaRecorder = MediaRecorder(stream);

    _audioBlobParts = [];
    _mediaRecorder.addEventListener('dataavailable', _onDataAvailable);
  }

  void _onDataAvailable(Event event) {
    final blobEvent = event as BlobEvent;

    _audioBlobParts.add(blobEvent.data);
  }

  Future<void> start() async {
    assert(_mediaRecorder != null);

    _mediaRecorder.start();
  }

  /// Stops the recorder and returns an URL pointing to the recording.
  Future<String> stop() async {
    assert(_mediaRecorder != null);

    final completer = Completer<String>();

    void onStop(_) {
      assert(_audioBlobParts != null);

      final blob = Blob(_audioBlobParts);
      _audioBlobParts = null;

      completer.complete(Url.createObjectUrl(blob));
    }

    _mediaRecorder.addEventListener('stop', onStop);
    _mediaRecorder.stop();
    final url = await completer.future;
    _mediaRecorder.removeEventListener('stop', onStop);

    return url;
  }

  void dispose() {
    assert(_mediaRecorder != null);

    _mediaRecorder.removeEventListener('dataavailable', _onDataAvailable);
    _mediaRecorder = null;
  }
}
