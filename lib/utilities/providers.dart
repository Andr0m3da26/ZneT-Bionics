import "dart:convert";
import "dart:async";
import "dart:typed_data";
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:web_socket_channel/io.dart";
import "package:web_socket_channel/web_socket_channel.dart";
import "package:web_socket_channel/status.dart" as status;

final screenIndexProvider = NotifierProvider<ScreenIndex, int>(() {
  return ScreenIndex();
});

class ScreenIndex extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void changeScreen(index) {
    state = index;
  }
}

final cameraToggleProvider = NotifierProvider<IsCameraToggle, bool>(() {
  return IsCameraToggle();
});

class IsCameraToggle extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}

final virtualCanvasToggleProvider =
    NotifierProvider<IsVirtualCanvasToggle, bool>(() {
  return IsVirtualCanvasToggle();
});

class IsVirtualCanvasToggle extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}

final recordingToggleProvider = NotifierProvider<IsRecordingToggle, bool>(() {
  return IsRecordingToggle();
});

class IsRecordingToggle extends Notifier<bool> {
  @override
  bool build() {
    // debugPrint("recording toggle");
    return false;
  }

  void toggle() {
    state = !state;
    ref
        .read(websocketCommmandsProvider.notifier)
        .sendCommand(jsonEncode({"command": "record", "record": state}));
  }
}

// final videoStreamProvider = StreamProvider.autoDispose<Map>((ref) async* {
//   final channel = IOWebSocketChannel.connect("ws://localhost:5000");
//   ref.onDispose(() => channel.sink.close());
//   channel.sink.add('{"command": "stream", "virtualcanvas": false}');
//   debugPrint(ref.watch(recordingToggleProvider).toString());
//   await for (final json in channel.stream) {
//     // A new message has been received. Let"s add it to the list of all messages.
//     // allMessages = [...allMessages, message];
//     final Map data = jsonDecode(json);
//     data["image"] = Uint8List.fromList(base64Decode(data["image"]));
//     yield data;
//   }
// });

// final virtualCanvasProvider = FutureProvider.autoDispose<Map>((ref) async {
//   final channel = IOWebSocketChannel.connect("ws://localhost:5000");
//   ref.onDispose(() => channel.sink.close());
//   channel.sink.add(jsonEncode(
//       {"command": "video", "path": ref.watch(fileSelectedProvider)}));

//   final Map data = jsonDecode(await channel.stream.first);
//   return data;
// });

// final videoStreamAndVirtualCanvasProvider =
//     StreamProvider.autoDispose<Map>((ref) async* {
//   final channel = IOWebSocketChannel.connect("ws://localhost:5000");
//   ref.onDispose(() => channel.sink.close());
//   channel.sink.add('{"command": "stream", "virtualcanvas": true}');
//   debugPrint(ref.watch(recordingToggleProvider).toString());
//   await for (final json in channel.stream) {
//     // A new message has been received. Let"s add it to the list of all messages.
//     // allMessages = [...allMessages, message];
//     final Map data = jsonDecode(json);
//     data["image"] = Uint8List.fromList(base64Decode(data["image"]));
//     yield data;
//   }

//   // channel.sink.add(jsonEncode({"record": ref.watch(recordingToggleProvider)}));
// });

final websocketCommmandsProvider =
    NotifierProvider<WebsocketCommands, IOWebSocketChannel>(() {
  return WebsocketCommands();
});

class WebsocketCommands extends Notifier<IOWebSocketChannel> {
  @override
  IOWebSocketChannel build() {
    return IOWebSocketChannel.connect("ws://localhost:5000");
  }

  void sendCommand(String command) {
    state.sink.add(command);
  }
}

final videoStreamProvider = StreamProvider.autoDispose<Map>((ref) async* {
  final IOWebSocketChannel? channel = ref.watch(websocketCommmandsProvider);
  final WebsocketCommands channelNotifier =
      ref.watch(websocketCommmandsProvider.notifier);
  ref.onDispose(() {
    channel!.sink.close();
  });
  channelNotifier
      .sendCommand(jsonEncode({"command": "stream", "virtualcanvas": false}));
  // debugPrint(ref.watch(recordingToggleProvider).toString());
  await for (final json in channel!.stream) {
    // A new message has been received. Let"s add it to the list of all messages.
    // allMessages = [...allMessages, message];
    final Map data = jsonDecode(json);
    data["image"] = Uint8List.fromList(base64Decode(data["image"]));
    yield data;
  }
});

final virtualCanvasProvider = FutureProvider.autoDispose<Map>((ref) async {
  final IOWebSocketChannel? channel = ref.watch(websocketCommmandsProvider);
  final WebsocketCommands channelNotifier =
      ref.watch(websocketCommmandsProvider.notifier);
  ref.onDispose(() {
    channel!.sink.close();
  });
  channelNotifier.sendCommand(jsonEncode(
      {"command": "video", "path": ref.watch(fileSelectedProvider)}));

  final Map data = jsonDecode(await channel!.stream.first);
  return data;
});

final videoStreamAndVirtualCanvasProvider =
    StreamProvider.autoDispose<Map>((ref) async* {
  final IOWebSocketChannel? channel = ref.watch(websocketCommmandsProvider);
  final WebsocketCommands channelNotifier =
      ref.watch(websocketCommmandsProvider.notifier);
  ref.onDispose(() {
    channel!.sink.close();
  });
  channelNotifier
      .sendCommand(jsonEncode({"command": "stream", "virtualcanvas": true}));

  // debugPrint(ref.watch(recordingToggleProvider).toString());
  await for (final json in channel!.stream) {
    // A new message has been received. Let"s add it to the list of all messages.
    // allMessages = [...allMessages, message];
    final Map data = jsonDecode(json);
    data["image"] = Uint8List.fromList(base64Decode(data["image"]));
    yield data;
  }

  // channel.sink.add(jsonEncode({"record": ref.watch(recordingToggleProvider)}));
});

final fileSelectedProvider = NotifierProvider<FileSelected, String>(() {
  return FileSelected();
});

class FileSelected extends Notifier<String> {
  @override
  String build() {
    return "";
  }

  void selectFile(String path) {
    state = path;
    debugPrint(state);
  }
}
