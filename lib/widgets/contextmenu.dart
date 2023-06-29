import 'package:flutter/material.dart';

class ContextMenu extends StatelessWidget {
  final List<String> items;
  const ContextMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // Callback that sets the selected popup menu item.
      onSelected: (item) {
        debugPrint(item.toString());
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
