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
    if (isCameraToggle) {
      final videoStream = ref.watch(videoStreamProvider);
      videoStream.whenData((data) {
        debugPrint(data['keypoints'].toString());
        keypoints.add(data['keypoints']);
      });
      // return AspectRatio(
      //   aspectRatio: 2,
      //   child: LineChart(
      //     LineChartData(
      //       lineBarsData: [
      //         LineChartBarData(
      //           spots: [],
      //           isCurved: false,
      //           // dotData: FlDotData(
      //           //   show: false,
      //           // ),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
    }
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots:
                  // keypoints.map((point) => FlSpot(point.x, point.y)).toList(),
                  // keypoints.map((frame) => FlSpot(, frame[0][1])).toList(),
                  // List graphData = List.from(keypoints),
                  // keypoints.asMap().forEach((frame, index) => FlSpot(index, frame[0][1])),
                  keypoints
                      .asMap()
                      .entries
                      .map((entry) =>
                          FlSpot(entry.key.toDouble(), entry.value[11][1]))
                      .toList(),
              isCurved: false,
              // dotData: FlDotData(
              //   show: false,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
