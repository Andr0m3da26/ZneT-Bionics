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

final websocketStreamProvider = Provider((ref) {
  final channel = ref.watch(websocketProvider);
  return channel.stream.asBroadcastStream();
});

final websocketProvider = NotifierProvider<Channel, WebSocketChannel>(() {
  return Channel();
});

class Channel extends Notifier<WebSocketChannel> {
  @override
  WebSocketChannel build() {
    return IOWebSocketChannel.connect("ws://localhost:5000");
  }

  void send(String message) {
    state.sink.add(message);
  }
}

final virtualCanvasProvider = FutureProvider.autoDispose<Map>((ref) async {
  // final channel = ref.watch(websocketProvider);
  final stream = ref.watch(websocketStreamProvider);
  // ref.onDispose(() => channel.sink.close());
  // channel.sink.add(jsonEncode(
  //     {"command": "video", "path": ref.watch(fileSelectedProvider)}));

  final Map data = jsonDecode(await stream.first);
  return data;
});

final videoStreamAndVirtualCanvasProvider =
    StreamProvider.autoDispose<Map>((ref) async* {
  // final channel = ref.watch(websocketProvider);
  final stream = ref.watch(websocketStreamProvider);
  // final channelNotifier = ref.watch(websocketProvider.notifier);

  // debugPrint("sending message");
  // channelNotifier.send(jsonEncode({'isCameraToggle': true}));
  // debugPrint("sent message");

  await for (final json in stream) {
    // A new message has been received. Let"s add it to the list of all messages.
    // allMessages = [...allMessages, message];
    final Map data = jsonDecode(json);
    data["camdata"] = Uint8List.fromList(base64Decode(data["camdata"]));
    data["vcdata"] = Uint8List.fromList(base64Decode(data["vcdata"]));
    yield data;
  }
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
