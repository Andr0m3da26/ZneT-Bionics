import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileExplorer extends StatelessWidget {
  final String directoryPath;

  const FileExplorer({super.key, required this.directoryPath});

  @override
  Widget build(BuildContext context) {
    final directory = Directory(directoryPath);
    final files = directory.listSync();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: files.length,
      itemBuilder: (BuildContext context, int index) {
        final file = files[index];
        final fileName = path.basename(file.path);
        if (file is Directory) {
          return ExpansionTile(
            title: Folder(file: file),
            // leading: Icon(file is Directory ? Icons.folder : Icons.file_copy),
            controlAffinity: ListTileControlAffinity.leading,
            onExpansionChanged: (isExpanded) {
              if (isExpanded) {}
            },
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: FileExplorer(directoryPath: file.path),
              )
            ],
          );
        } else {
          return ListTile(
            title: Text(fileName),
            leading: Icon(file is Directory ? Icons.folder : Icons.file_copy),
          );
        }
      },
    );
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
        Icon(file is Directory ? Icons.folder : Icons.file_copy),
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
