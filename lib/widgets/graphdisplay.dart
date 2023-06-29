import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GraphDisplay extends ConsumerStatefulWidget {
  const GraphDisplay({Key? key}) : super(key: key);

  @override
  GraphDisplayState createState() => GraphDisplayState();
}

class GraphDisplayState extends ConsumerState<GraphDisplay> {
  List keypoints = [];

  @override
  Widget build(BuildContext context) {
    final bool isCameraToggle = ref.watch(cameraToggleProvider);
    final bool isVirtualCanvasToggle = ref.watch(virtualCanvasToggleProvider);
    if (isCameraToggle && isVirtualCanvasToggle) {
      final stream = ref.watch(videoStreamAndVirtualCanvasProvider);
      stream.whenData((data) {
        debugPrint(data['keypoints'].toString());
        keypoints.add(data['keypoints']);
      });
    }
    if (!isCameraToggle && isVirtualCanvasToggle) {
      final video = ref.watch(virtualCanvasProvider);
      video.whenData((data) {
        keypoints = data['keypoints'];
      });
    }
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: keypoints
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
    );
  }
}
