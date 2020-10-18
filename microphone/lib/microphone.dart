import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:microphone_platform_interface/microphone_platform_interface.dart';

final _microphonePlatform = MicrophonePlatformInterface.instance;

/// The state and result of a recorder.
class MicrophoneRecorderValue {
  /// Constructs a recorder given the values.
  const MicrophoneRecorderValue({
    @required this.started,
    @required this.stopped,
    @required this.recording,
  })  : assert(started != null),
        assert(stopped != null),
        assert(!stopped || started),
        assert(recording == null || stopped);

  /// Whether the recorder has been started yet.
  ///
  /// This will stay `true`, even when the recorder has been stopped.
  /// The reason for this is that a microphone recorder is only allowed
  /// to perform a single recording.
  final bool started;

  /// Whether the recorder has been stopped.
  ///
  /// This `false` if `started` is `false` and `true` if
  /// `started` is true **and** the recording has been stopped.
  ///
  /// When this is `true`, [recording] will be available as the result
  /// of the recorder.
  final bool stopped;

  /// The result of the recorder, i.e. the recording.
  ///
  /// This is `null` before [stopped] is `true`.
  final MicrophoneRecording recording;

  /// Returns a new instance that has the same values as this current instance,
  /// except for any overrides passed in as arguments to [copyWidth].
  MicrophoneRecorderValue copyWith({
    bool started,
    bool stopped,
    MicrophoneRecording recording,
  }) {
    return MicrophoneRecorderValue(
      started: started ?? this.started,
      stopped: stopped ?? this.stopped,
      recording: recording ?? this.recording,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'start: $started, '
        'stopped: $stopped, '
        'recording: $recording)';
  }
}

/// The result of a microphone recorder.
class MicrophoneRecording {
  /// Constructs a [MicrophoneRecording] given recording results.
  const MicrophoneRecording({
    this.url,
  });

  /// A URL pointing to the recording.
  final String url;

  @override
  String toString() {
    return '$runtimeType('
        'url: $url)';
  }
}

/// Controls a platform microphone recorder and provides updates when the
/// state is changing.
class MicrophoneRecorder extends ValueNotifier<MicrophoneRecorderValue> {
  /// Constructs a microphone recorder in the initial state.
  MicrophoneRecorder()
      : super(MicrophoneRecorderValue(
          started: false,
          stopped: false,
          recording: null,
        ));

  int _recorderId;

  var _initialized = false, _disposed = false;

  /// Initializes the recorder.
  ///
  /// This has to be called before any other method is called and
  /// can only be called once.
  Future<void> init() async {
    _checkNotDisposed();
    assert(!_initialized, 'Cannot initialize a recorder twice.');

    _recorderId = await _microphonePlatform.create();
    _initialized = true;
  }

  void _checkInitialized() {
    assert(
        _initialized,
        'You need to call init() on the microphone '
        'recorder before using any other methods.');
  }

  /// Starts the recorder.
  Future<void> start() async {
    _checkInitialized();
    _checkNotDisposed();
    assert(!value.started, 'The recorder can only be started once.');

    await _microphonePlatform.start(_recorderId);
    value = value.copyWith(started: true);
  }

  /// Stops the recorder.
  ///
  /// [start] has to have been called before this can be called.
  ///
  /// The recording will be available in the recording after
  /// the recorder has been stopped.
  Future<void> stop() async {
    _checkInitialized();
    _checkNotDisposed();
    assert(value.started,
        'The recorder has to be started before it can be stopped.');
    assert(!value.stopped, 'The recorder can only be stopped once.');

    final recording = await _microphonePlatform.stop(_recorderId);
    value = value.copyWith(
      stopped: true,
      recording: MicrophoneRecording(url: recording),
    );
  }

  /// Disposes the recorder.
  ///
  /// Make sure to call this when not using
  void dispose() {
    _checkInitialized();
    _checkNotDisposed();

    _microphonePlatform.dispose(_recorderId);
    super.dispose();
    _disposed = true;
  }

  void _checkNotDisposed() {
    assert(
        !_disposed,
        'You cannot call any method of a microphone '
        'recorder after it has been disposed.');
  }
}
