import "dart:convert";
import "dart:async";
import "dart:io";

import "dart:typed_data";
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:web_socket_channel/io.dart";
import "package:web_socket_channel/web_socket_channel.dart";
import "package:web_socket_channel/status.dart" as status;
import 'package:uuid/uuid.dart';
import 'package:file_selector/file_selector.dart';
import 'package:providerarchitecturetest/widgets/newproject.dart';

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
    //print if websocket connection is closed
    debugPrint(state.closeCode.toString());
    if (state.closeCode != null) {
      state = IOWebSocketChannel.connect("ws://localhost:5000");
    }
    state.sink.add(message);
  }
}

final virtualCanvasProvider = FutureProvider.autoDispose<Map>((ref) async {
  // final channel = ref.watch(websocketProvider);
  final stream = ref.watch(websocketStreamProvider);
  final graphsListNotifier = ref.watch(graphsProvider.notifier);
  // ref.onDispose(() => channel.sink.close());
  // channel.sink.add(jsonEncode(
  //     {"command": "video", "path": ref.watch(fileSelectedProvider)}));

  final Map data = jsonDecode(await stream.first);
  graphsListNotifier.addGraph(Graph(
      id: const Uuid().v1(),
      keypoints: data['keypoints'],
      date: DateTime.now()));
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

final projectPathProvider = NotifierProvider<ProjectPath, Directory?>(() {
  return ProjectPath();
});

class ProjectPath extends Notifier<Directory?> {
  @override
  Directory? build() {
    return null;
  }

  void selectDirectory(String path) {
    state = Directory(path);
    debugPrint(state!.path);
  }
}

class Graph {
  Graph(
      {required this.id,
      this.keypoints = const [],
      this.title = "Untitled Graph",
      required this.date});
  final String id;
  List? keypoints;
  String? title;
  final DateTime date;
}

final graphsProvider = NotifierProvider<GraphsList, List<Graph>>(() {
  return GraphsList();
});

class GraphsList extends Notifier<List<Graph>> {
  @override
  List<Graph> build() {
    return [];
  }

  void addGraph(Graph graph) {
    state = [...state, graph];
  }

  void removeGraph(Graph graph) {
    state = state.where((element) => element != graph).toList();
  }
}

final graphSelectedProvider = NotifierProvider<GraphSelected, Graph?>(() {
  return GraphSelected();
});

class GraphSelected extends Notifier<Graph?> {
  @override
  Graph? build() {
    return null;
  }

  void selectGraph(String id) {
    ref.watch(graphsProvider).forEach((graph) {
      if (graph.id == id) {
        state = graph;
      }
    });
  }
}

enum ProjectOptions { openProject, newProject }

enum SettingsOptions { preferences, help, exit }

final projectOptionsHandler = NotifierProvider<ProjectOptionsHandler, bool>(() {
  return ProjectOptionsHandler();
});

class ProjectOptionsHandler extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void handleSelection(item, BuildContext context) {
    switch (item) {
      case ProjectOptions.newProject:
        debugPrint("new project");
        newProject(context);
        break;
      case ProjectOptions.openProject:
        debugPrint("open project");
        openProject();
        break;
      default:
        debugPrint("invalid item");
        break;
    }
  }

  void newProject(BuildContext context) async {
    String? strFolderDir = await getDirectoryPath();
    if (strFolderDir == null) {
      return;
    }
    Directory folderDir = Directory(strFolderDir);
    debugPrint(folderDir.path);

    String? projectName = await dialogBuilder(context, strFolderDir);
    if (projectName == null) {
      return;
    }
    // create a new folder in the directory
    Directory('$strFolderDir\\$projectName\\Videos')
        .createSync(recursive: true);
    Directory('$strFolderDir\\$projectName\\Data').createSync(recursive: true);
    ref
        .watch(projectPathProvider.notifier)
        .selectDirectory('$strFolderDir\\$projectName');
  }

  void openProject() async {
    // debugPrint("open project");
    String? strFolderDir = await getDirectoryPath();
    if (strFolderDir == null) {
      return;
    }
    ref.watch(projectPathProvider.notifier).selectDirectory(strFolderDir);
  }
}

final fileOptionsHandler = NotifierProvider<FileOptionsHandler, bool>(() {
  return FileOptionsHandler();
});

class FileOptionsHandler extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void handleSelection(String item, String path) {
    switch (item) {
      case "Add file...":
        debugPrint("add file");
        addFile(path);
        break;
      case "Rename":
        debugPrint("rename");
        renameFile(path, "newName");
        break;
      case "Delete":
        debugPrint("delete");
        deleteFile(path);
        break;
      default:
        debugPrint("invalid item");
        break;
    }
  }

  void addFile(String path) async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'videos or text files',
      extensions: <String>['.mp4', '.avi', '.mkv', '.mov', '.txt'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    if (file == null) {
      return;
    }
    await File(file.path).rename('$path\\${file.name}');
  }

  void renameFile(String path, String newName) async {
    // const XTypeGroup typeGroup = XTypeGroup(
    //   label: 'videos or text files',
    //   extensions: <String>['.mp4', '.avi', '.mkv', '.mov', '.txt'],
    // );
    // final XFile? file =
    //     await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    // if (file == null) {
    //   return;
    // }
    int lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    String newPath = path.substring(0, lastSeparator + 1) + newName;

    await File(path).rename(newPath);
  }

  void deleteFile(String path) async {}
}
