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
      final videoStream = ref.watch(videoStreamProvider);
      return videoStream.when(
        data: (data) {
          return Expanded(
            child: Image.memory(
              data['image'],
              gaplessPlayback: true,
              excludeFromSemantics: true,
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      );
    }

    if (isCameraToggle && !isVirtualCanvasToggle) {}
    if (isVirtualCanvasToggle && !isCameraToggle) {}
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[600]),
      ),
    );
  }
}
