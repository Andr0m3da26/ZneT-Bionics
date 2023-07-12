import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';

class ContextMenu extends ConsumerWidget {
  final List<String> items;
  final String path;
  const ContextMenu({super.key, required this.items, required this.path});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileOptions = ref.watch(fileOptionsHandler.notifier);
    return PopupMenuButton(
      // Callback that sets the selected popup menu item.
      onSelected: (String item) {
        debugPrint(item.toString());
        // switch (item) {
        //   case "Add file...":
        //     debugPrint("Add file...");
        //     break;
        //   case "Rename":
        //     debugPrint("Rename");
        //     break;
        //   case "Delete":
        //     debugPrint("Delete");
        //     break;
        //   default:
        //     debugPrint("Unknown");
        // }
        fileOptions.handleSelection(item, path);
      },
      itemBuilder: (BuildContext context) => items
          .map((item) => PopupMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
    );
  }
}
