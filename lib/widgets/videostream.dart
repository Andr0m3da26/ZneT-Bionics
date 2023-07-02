import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoStream extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isCameraToggle = ref.watch(cameraToggleProvider);

    final bool isVirtualCanvasToggle = ref.watch(virtualCanvasToggleProvider);
    if (isCameraToggle && isVirtualCanvasToggle) {
      final videoStream = ref.watch(videoStreamAndVirtualCanvasProvider);
      return videoStream.when(
        data: (data) {
          return Positioned.fill(
            child: Image.memory(
              data['image'],
              gaplessPlayback: true,
              excludeFromSemantics: true,
            ),
          );
        },
        loading: () => Center(child: const CircularProgressIndicator()),
        error: (err, stack) => Text('Error: $err'),
      );
    }

    if (isCameraToggle && !isVirtualCanvasToggle) {}
    if (isVirtualCanvasToggle && !isCameraToggle) {
      final virtualCanvas = ref.watch(virtualCanvasProvider);
      return virtualCanvas.when(
        data: (data) {
          return Container(child: Text("success"));
        },
        loading: () => Center(child: const CircularProgressIndicator()),
        error: (err, stack) => Text('Error: $err'),
      );
    }
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select a video to display, or turn on the camera",
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
