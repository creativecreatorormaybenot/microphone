# microphone [![Pub version](https://img.shields.io/pub/v/microphone.svg)](https://pub.dev/packages/microphone) [![GitHub stars](https://img.shields.io/github/stars/creativecreatorormaybenot/microphone.svg)](https://github.com/creativecreatorormaybenot/microphone) [![Twitter Follow](https://img.shields.io/twitter/follow/creativemaybeno?label=Follow&style=social)](https://twitter.com/creativemaybeno)

Flutter (web-only at this moment) plugin for recording audio through the microphone.

## Usage

To use this plugin, follow the [installing guide](https://pub.dev/packages/microphone/install).

### Recording microphone audio

You need to create and initialize a `MicrophoneRecorder` in order to record audio.  
Note that a single recorder can only make a single recording. Simply create a new recorder
if you want to make another recording. Further note that you can also record simultaneously.

```dart
import 'package:microphone/microphone.dart';
// ...

// Create and initialize a recorder.
final microphoneRecorder = MicrophoneRecorder()..init();
```

The initialization happens asynchronously, which means that you might need to `await` the `init` method.

Now, you can start a recording.

```dart
import 'package:microphone/microphone.dart';
// ...

// Start recording audio.
microphoneRecorder.start();
```

Stopping it will give you access to a `MicrophoneRecording` in the `value` property:

```dart
import 'package:microphone/microphone.dart';
// ...

// Stop the recording.
await microphoneRecorder.stop();
final recordingUrl = microphoneRecorder.value.recording.url;
```

The recording is accessible through a URL and can be played back using e.g. [`just_audio`](https://pub.dev/packages/just_audio)'s "read from URL"
(requires adding a `just_audio_web` dependency as well; see the [example app]).

**Do not forget** to *dispose* the recorder:

```dart
import 'package:microphone/microphone.dart';
// ...

// Dispose the recorder.
microphoneRecorder.dispose();
```

### Listening to state changes

`MicrophoneRecorder` is also a `ValueNotifier`, which means that it can e.g. be used with a Flutter `ValueListenableBuilder`
or you can attach a listener using `MicrophoneRecorder.addListener`.  
Whenever `MicrophoneRecorder.value.started` or `MicrophoneRecorder.value.stopped` changed, you will be notified. See the
[example app] for an example usage.

## Learn more

If you want to learn more about how this plugin works, how to contribute, etc., you can read through
the [main README on GitHub](https://github.com/creativecreatorormaybenot/microphone).

[example app]: https://github.com/creativecreatorormaybenot/microphone/tree/main/microphone/example
