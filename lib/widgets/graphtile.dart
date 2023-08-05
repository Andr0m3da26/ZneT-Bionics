import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/widgets/contextmenu.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';

// This is the GraphTile widget, which is a StatelessWidget that displays a single graph tile
class GraphTile extends StatelessWidget {
  final int index;
  final Graph graph;
  final VoidCallback onTap;
  final Key key;
  const GraphTile(
      {required this.index,
      required this.graph,
      required this.onTap,
      required this.key});

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 40),
        minVerticalPadding: 40,
        key: key,
        title: Text(
            style: Theme.of(context).textTheme.titleLarge, "${graph.title}"),
        subtitle: Text("${graph.date.toString().substring(0, 16)}"),
        trailing: ContextMenu(items: ["Rename", "Delete"], path: ""),
        onTap: onTap,
      ),
    );
  }
}
