# nim_core_web

A Flutter web plugin for NetEase IM SDK.

To learn more about `NIM`, please visit the [website](https://yunxin.163.com/im)

## Getting Started

To get started with `NIM` for Flutter,
please [see the documentation](https://doc.yunxin.163.com/docs/TM5MzM5Njk/TU3NDk1OTI?platformId=120326)


## Usage

To implement a new platform-specific implementation of `nim_core`, extend
[`NimCorePlatform`][2] with an implementation that performs the platform-specific behavior, and when
you register your plugin, set the default
`NimCorePlatform` by calling
`NimCorePlatform.instance = MyService()`.

[1]: https://pub.dev/packages/nim_core
