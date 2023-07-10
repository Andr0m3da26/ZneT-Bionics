import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:providerarchitecturetest/widgets/graphtile.dart';

class GraphRack extends ConsumerWidget {
  const GraphRack({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphSelectedNotifier = ref.watch(graphSelectedProvider.notifier);
    return Container(
      width: 400,
      decoration: BoxDecoration(color: Colors.white),
      child: ReorderableListView(
          buildDefaultDragHandles: false,
          children: [
            for (Graph graph in ref.watch(graphsProvider))
              GraphTile(
                  key: Key(graph.id),
                  index: ref.watch(graphsProvider).indexOf(graph),
                  graph: graph,
                  onTap: () {
                    graphSelectedNotifier.selectGraph(graph.id);
                  }),
          ],
          onReorder: (int oldIndex, int newIndex) {
            debugPrint("Old index: $oldIndex, New index: $newIndex");
          }),
    );
  }
}
