import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

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

final videoStreamProvider = StreamProvider.autoDispose<Map>((ref) async* {
  final channel = IOWebSocketChannel.connect('ws://localhost:5000');
  ref.onDispose(() => channel.sink.close());
  // channel.sink.add('Hello!');
  await for (final json in channel.stream) {
    // A new message has been received. Let's add it to the list of all messages.
    // allMessages = [...allMessages, message];
    final Map data = jsonDecode(json);
    data['image'] = Uint8List.fromList(base64Decode(data['image']));
    yield data;
  }
});
