import "dart:convert";
import "dart:async";
import "dart:typed_data";

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

final videoStreamProvider = StreamProvider.autoDispose<Map>((ref) async* {
  final channel = IOWebSocketChannel.connect("ws://localhost:5000");
  ref.onDispose(() => channel.sink.close());
  channel.sink.add('{"command": "stream", "virtualcanvas": false"}');
  await for (final json in channel.stream) {
    // A new message has been received. Let"s add it to the list of all messages.
    // allMessages = [...allMessages, message];
    final Map data = jsonDecode(json);
    data["image"] = Uint8List.fromList(base64Decode(data["image"]));
    yield data;
  }
});

final videoProvider = FutureProvider.autoDispose<Map>((ref) async {
  final channel = IOWebSocketChannel.connect("ws://localhost:5000");
  ref.onDispose(() => channel.sink.close());
  void sendVideo(String path) async {
    channel.sink.add('{"command": "video", "path": "$path"}');
    final success = await channel.stream.first;
  }

  final json = await channel.stream.first;
  final Map data = jsonDecode(json);
  data["image"] = Uint8List.fromList(base64Decode(data["image"]));
  return data;
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
  }
}
