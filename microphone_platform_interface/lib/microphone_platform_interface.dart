import 'package:meta/meta.dart';
import 'package:microphone_platform_interface/method_channel_microphone.dart';

/// The interface that implementations of microphone must implement.
///
/// Platform implementations should extend this class rather than implement it
/// because `implements` does not consider newly added methods to be breaking
/// changes. Extending this class (using `extends`) ensures that the subclass
/// will get the default implementation.
abstract class MicrophonePlatformInterface {
  static MicrophonePlatformInterface _instance = MethodChannelMicrophone();

  /// The default instance of the [MicrophonePlatformInterface] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [MicrophonePlatformInterface] when they
  /// register themselves.
  ///
  /// Defaults to [MethodChannelMicrophone].
  static MicrophonePlatformInterface get instance => _instance;

  /// Sets the default instance of the [MicrophonePlatformInterface].
  ///
  /// This will be removed after https://github.com/flutter/flutter/issues/43368
  /// has been resolved.
  static set instance(MicrophonePlatformInterface instance) {
    if (!instance.isMock) {
      try {
        instance._verifyProvidesDefaultImplementations();
      } on NoSuchMethodError catch (_) {
        throw AssertionError(
            'Platform interfaces must not be implemented with `implements`');
      }
    }
    _instance = instance;
  }

  /// Only mock implementations should set this to true.
  ///
  /// Mockito mocks are implementing this class with `implements`, which is
  /// forbidden for anything other than mocks (see class docs). This property
  /// provides a backdoor for mockito mocks to skip the verification that the
  /// class is not implemented with `implements`.
  @visibleForTesting
  bool get isMock => false;

  /// Creates an instance of a microphone recorder and returns its recorder ID.
  Future<int> create() {
    throw UnimplementedError('create() has not been implemented.');
  }

  /// Starts the recording of the microphone recorder with the given [recorderId].
  Future<void> start(int recorderId) {
    throw UnimplementedError('start() has not been implemented.');
  }

  /// Stops the recording of the recorder with [recorderId] and returns its recording URL.
  Future<String> stop(int recorderId) {
    throw UnimplementedError('stop() has not been implemented.');
  }

  /// Disposes one microphone recorder that has the given [recorderId].
  Future<void> dispose(int recorderId) {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  // This method makes sure that VideoPlayer isn't implemented with `implements`.
  //
  // See class doc for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter, which fails if the
  // class is implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}
}
