import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:providerarchitecturetest/widgets/graphtile.dart';

// This is the GraphRack widget, which is a ConsumerWidget that displays a list of graphs
class GraphRack extends ConsumerWidget {
  const GraphRack({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the graphSelectedNotifier from the graphSelectedProvider
    final graphSelectedNotifier = ref.watch(graphSelectedProvider.notifier);
    // Build the graph rack
    return Container(
      width: 400,
      decoration: BoxDecoration(color: Colors.white),
      child: ReorderableListView(
          buildDefaultDragHandles: false,
          children: [
            // Build a graph tile for each graph in the graphsProvider
            for (Graph graph in ref.watch(graphsProvider))
              GraphTile(
                  key: Key(graph.id),
                  index: ref.watch(graphsProvider).indexOf(graph),
                  graph: graph,
                  onTap: () {
                    // When a graph is tapped, select it using the graphSelectedNotifier
                    graphSelectedNotifier.selectGraph(graph.id);
                  }),
          ],

          // When a graph is reordered, reorder the graphsProvider
          onReorder: (int oldIndex, int newIndex) {
            // TO DO
          }),
    );
  }
}
