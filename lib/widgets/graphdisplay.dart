import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter/material.dart';

// This is the GraphDisplay widget, which is a ConsumerStatefulWidget that displays a graph
class GraphDisplay extends ConsumerStatefulWidget {
  const GraphDisplay({Key? key}) : super(key: key);

  @override
  GraphDisplayState createState() => GraphDisplayState();
}

// This is the GraphDisplayState class, which is a ConsumerState that manages the state of the GraphDisplay widget
class GraphDisplayState extends ConsumerState<GraphDisplay> {
  @override
  Widget build(BuildContext context) {
    // Get the selected graph from the graphSelectedProvider
    final selectedGraph = ref.watch(graphSelectedProvider);

    // If a graph is selected, display it
    return selectedGraph != null
        ? AspectRatio(
            aspectRatio: 2,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: selectedGraph.keypoints!
                        .asMap()
                        .entries
                        .map((entry) =>
                            FlSpot(entry.key.toDouble(), entry.value[11][1]))
                        .toList(),
                    isCurved: false,
                  ),
                ],
              ),
            ),
          )
        // If no graph is selected, display a message
        : Container(
            decoration: BoxDecoration(color: Colors.grey),
            child: Center(
                child: Text(
              "Click a graph to display it here.",
              style: Theme.of(context).textTheme.titleMedium,
            )),
          );
  }
}
