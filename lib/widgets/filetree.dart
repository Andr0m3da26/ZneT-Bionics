import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:providerarchitecturetest/widgets/contextmenu.dart';

bool _isVideo(FileSystemEntity file) {
  final videoExtensions = ['.mp4', '.avi', '.mkv', '.mov'];
  final extension = path.extension(file.path).toLowerCase();
  return videoExtensions.contains(extension);
}

bool _isTextFile(FileSystemEntity file) {
  final textExtensions = ['.txt'];
  final extension = path.extension(file.path).toLowerCase();
  return textExtensions.contains(extension);
}

class FileExplorer extends ConsumerWidget {
  final String? directoryPath;
  final int tilePadding;

  const FileExplorer(
      {super.key, required this.directoryPath, required this.tilePadding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final projectPath = ref.watch(projectPathProvider);

    if (directoryPath == null) {
      return SizedBox(
        width: 300,
      );
    } else {
      final directory = Directory(directoryPath!);
      final files = directory.listSync();
      // final files = projectPath.listSync();
      return Container(
        width: 300,
        alignment: AlignmentDirectional.topStart,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: files.length,
          itemBuilder: (BuildContext context, int index) {
            final file = files[index];
            if (file is Directory) {
              return ExpansionTile(
                collapsedBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                title: Folder(file: file),
                // leading: Icon(file is Directory ? Icons.folder : Icons.file_copy),

                controlAffinity: ListTileControlAffinity.leading,
                onExpansionChanged: (isExpanded) {
                  if (isExpanded) {}
                },
                tilePadding: EdgeInsets.only(left: tilePadding.toDouble()),
                children: [
                  FileExplorer(
                      directoryPath: file.path, tilePadding: tilePadding + 20),
                ],
                trailing: ContextMenu(
                  items: ["Add file...", "Rename", "Delete"],
                  path: file.path,
                ),
              );
            } else {
              return ListTile(
                tileColor: Colors.white,
                title: Row(
                  children: [
                    // Icon(_isVideo(file) ? Icons.video_library : Icons.file_copy),
                    SizedBox(width: 57),
                    if (_isVideo(file)) ...[
                      Icon(Icons.video_library)
                    ] else if (_isTextFile(file)) ...[
                      Icon(Icons.description)
                    ] else ...[
                      Icon(Icons.file_copy)
                    ],

                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        path.basename(file.path),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  ref
                      .watch(fileSelectedProvider.notifier)
                      .selectFile(file.path);
                  if (_isVideo(file)) {
                    ref.watch(playerProvider.notifier).open(file.path);

                    // ref.watch(playerProvider.notifier).seek(Duration.zero);
                  }
                },
                trailing: ContextMenu(
                  items: ["Rename", "Delete"],
                  path: file.path,
                ),
              );
            }
          },
        ),
      );
    }
  }
}

class Folder extends StatelessWidget {
  const Folder({
    super.key,
    required this.file,
  });

  final FileSystemEntity file;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.folder),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            path.basename(file.path),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
