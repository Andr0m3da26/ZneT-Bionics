import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';

// This is the ContextMenu widget, which is a ConsumerWidget that displays a context menu
class ContextMenu extends ConsumerWidget {
  final List<String> items;
  final String path;
  const ContextMenu({super.key, required this.items, required this.path});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the fileOptionsHandler notifier from the provider
    final fileOptions = ref.watch(fileOptionsHandler.notifier);
    // Build the popup menu button
    return PopupMenuButton(
      // Handle the selected item
      onSelected: (String item) {
        debugPrint(item.toString());

        fileOptions.handleSelection(item, path);
      },
      // Build the popup menu items
      itemBuilder: (BuildContext context) => items
          .map((item) => PopupMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
    );
  }
}
