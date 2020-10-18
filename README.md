# Microphone [![Publish workflow](https://github.com/creativecreatorormaybenot/microphone/workflows/Publish/badge.svg)](https://github.com/creativecreatorormaybenot/microphone/actions) [![GitHub stars](https://img.shields.io/github/stars/creativecreatorormaybenot/microphone.svg)](https://github.com/creativecreatorormaybenot/microphone) [![Pub version](https://img.shields.io/pub/v/microphone.svg)](https://pub.dev/packages/microphone)

Flutter (web-only at this moment) plugin for recording audio (using the microphone).

## Getting started

To learn more about the plugin and getting started, you can view [the main package (`microphone`) README](https://github.com/creativecreatorormaybenot/microphone/blob/master/microphone/README.md).

### Plugin structure

The `microphone` plugin uses the [federated plugins approach](https://flutter.dev/docs/development/packages-and-plugins/developing-packages#federated-plugins).  
For this plugin, it means that the basic API is defined using [`pigeon`](https://pub.dev/packages/pigeon). The pigeon files can be found in the [`pigeons` directory](https://github.com/creativecreatorormaybenot/microphone/tree/master/microphone/pigeons)
in the main package. The API is defined in Dart in the [`microphone_platform_interface` package](https://github.com/creativecreatorormaybenot/microphone/tree/master/microphone_platform_interface).  
Furthermore, the Android and iOS implementations can be found in the main package, while the web implementation is in the [`microphone_web` package](https://github.com/creativecreatorormaybenot/microphone/tree/master/microphone_platform_interface).

The packages in this repo are the following:

| Package                                                                                                                              | Implementations                                     |
| ------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------- |
| [`microphone`](https://github.com/creativecreatorormaybenot/microphone/tree/master/microphone)                                       | Main plugin package + Android & iOS implementations |
| [`microphone_platform_interface`](https://github.com/creativecreatorormaybenot/microphone/tree/master/microphone_platform_interface) | Basic API definition & message handling             |
| [`microphone_web`](https://github.com/creativecreatorormaybenot/microphone/tree/master/microphone_web)                               | Web implementation                                  |

## Contributing

If you want to contribute to this plugin, follow the [contributing guide](https://github.com/creativecreatorormaybenot/microphone/blob/master/.github/CONTRIBUTING.md).
