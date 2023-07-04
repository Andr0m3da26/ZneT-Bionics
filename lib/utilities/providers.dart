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

final virtualCanvasProvider = FutureProvider.autoDispose<Map>((ref) async {
  final channel = IOWebSocketChannel.connect("ws://localhost:5000");
  // ref.onDispose(() => channel.sink.close());
  channel.sink.add(jsonEncode(
      {"command": "video", "path": ref.watch(fileSelectedProvider)}));

  final Map data = jsonDecode(await channel.stream.first);
  return data;
});

final videoStreamAndVirtualCanvasProvider = StreamProvider<Map>((ref) async* {
  final channel = IOWebSocketChannel.connect("ws://localhost:5000");

  ref.onDispose(() => channel.sink.add(jsonEncode({'isCameraToggle': false})));
  debugPrint("sending message");
  channel.sink.add(jsonEncode({'isCameraToggle': true}));
  debugPrint("sent message");
  await for (final json in channel.stream) {
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
