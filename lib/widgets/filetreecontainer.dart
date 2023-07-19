import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:providerarchitecturetest/widgets/contextmenu.dart';

import 'package:providerarchitecturetest/widgets/filetree.dart';

class FileExplorer extends ConsumerWidget {
  final String? directoryPath;
  final int tilePadding;

  const FileExplorer(
      {super.key, required this.directoryPath, required this.tilePadding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final projectPath = ref.watch(projectPathProvider);
    final isFileTreeExpanded = ref.watch(fileTreeExpandedProvider);
    final isFileTreeExpandedNotifier =
        ref.watch(fileTreeExpandedProvider.notifier);
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: isFileTreeExpanded ? 300 : 100,
        // width: 300,
        child: Column(
          children: [
            IconButton(
                onPressed: () {
                  isFileTreeExpandedNotifier.toggle();
                  debugPrint('pressed');
                },
                // icon: isFileTreeExpanded
                //     ? Container(
                //         child: Row(children: [
                //         Icon(Icons.arrow_left),
                //         Icon(Icons.account_tree)
                //       ]))
                //     : Container(
                //         child: Row(children: [
                //         Icon(Icons.arrow_right),
                //         Icon(Icons.account_tree)
                //       ])),
                icon: Icon(Icons.expand)),
            isFileTreeExpanded
                ? FileExplorer(
                    directoryPath: directoryPath, tilePadding: tilePadding)
                : SizedBox(
                    width: 300,
                  ),
          ],
        ));
  }
}
