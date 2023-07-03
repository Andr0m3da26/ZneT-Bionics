import "dart:convert";
import "dart:async";
import "dart:io";
import 'package:path/path.dart' as Path;
import "dart:typed_data";
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:dart_vlc/dart_vlc.dart';
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
  channel.sink.add('{"command": "stream", "virtualcanvas": false}');
  await for (final json in channel.stream) {
    // A new message has been received. Let"s add it to the list of all messages.
    // allMessages = [...allMessages, message];
    final Map data = jsonDecode(json);
    data["image"] = Uint8List.fromList(base64Decode(data["image"]));
    yield data;
  }
});

final virtualCanvasProvider = FutureProvider.autoDispose<Map>((ref) async {
  final channel = IOWebSocketChannel.connect("ws://localhost:5000");
  ref.onDispose(() => channel.sink.close());
  channel.sink.add(jsonEncode(
      {"command": "video", "path": ref.watch(fileSelectedProvider)}));

  final Map data = jsonDecode(await channel.stream.first);
  return data;
});

final videoStreamAndVirtualCanvasProvider =
    StreamProvider.autoDispose<Map>((ref) async* {
  final channel = IOWebSocketChannel.connect("ws://localhost:5000");
  ref.onDispose(() => channel.sink.close());
  channel.sink.add('{"command": "stream", "virtualcanvas": true}');
  await for (final json in channel.stream) {
    // A new message has been received. Let"s add it to the list of all messages.
    // allMessages = [...allMessages, message];
    final Map data = jsonDecode(json);
    data["image"] = Uint8List.fromList(base64Decode(data["image"]));
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

final videoPlayerProvider = NotifierProvider<VideoPlayerClass, Video>(() {
  return VideoPlayerClass();
});

class VideoPlayerClass extends Notifier<Video> {
  List<Map<String, dynamic>> videoData = [];
  Player videoPlayer = Player(
    id: 00,
  );

  @override
  Video build() {
    return Video(
      player: videoPlayer,
      showControls: true,
    );
  }

  void open(String path) {
    String selectedFile = ref.watch(fileSelectedProvider);
    bool _isVideo(FileSystemEntity file) {
      final videoExtensions = ['.mp4', '.avi', '.mkv', '.mov'];
      final extension = Path.extension(file.path).toLowerCase();
      return videoExtensions.contains(extension);
    }

    if (_isVideo(File(selectedFile))) {
      videoPlayer.open(Media.file(File(selectedFile)));
    }
  }
}
