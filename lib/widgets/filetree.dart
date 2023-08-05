import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:providerarchitecturetest/widgets/contextmenu.dart';

// This function validates if the file is a video based on its extension
bool _isVideo(FileSystemEntity file) {
  final videoExtensions = ['.mp4', '.avi', '.mkv', '.mov'];
  final extension = path.extension(file.path).toLowerCase();
  return videoExtensions.contains(extension);
}

// This function validates if the file is a text file based on its extension
bool _isTextFile(FileSystemEntity file) {
  final textExtensions = ['.txt'];
  final extension = path.extension(file.path).toLowerCase();
  return textExtensions.contains(extension);
}

// This is the FileExplorer widget, which is a ConsumerWidget that displays a file explorer
class FileExplorer extends ConsumerWidget {
  final String? directoryPath;
  final int tilePadding;

  const FileExplorer(
      {super.key, required this.directoryPath, required this.tilePadding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If the directory path is not set, return an empty SizedBox
    if (directoryPath == null) {
      return SizedBox(
        width: 300,
      );
    } else {
      // Get the directory from the directory path
      final directory = Directory(directoryPath!);
      // Get the files from the directory
      final files = directory.listSync();
      // Build the file explorer
      return Container(
        width: 300,
        alignment: AlignmentDirectional.topStart,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: files.length,
          itemBuilder: (BuildContext context, int index) {
            final file = files[index];
            // If the file is a directory, return a folder tile
            if (file is Directory) {
              return ExpansionTile(
                collapsedBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                title: Folder(file: file),
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
              // Else if the file is not a directory, return a regular list tile
            } else {
              return ListTile(
                tileColor: Colors.white,
                title: Row(
                  children: [
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

// This is the Folder widget, which is a StatelessWidget that displays a folder
class Folder extends StatelessWidget {
  const Folder({
    super.key,
    required this.file,
  });

  final FileSystemEntity file;

  // Build the folder
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
