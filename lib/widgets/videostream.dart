import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoStream extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isCameraToggle = ref.watch(cameraToggleProvider);
    if (isCameraToggle) {
      final videoStream = ref.watch(videoStreamProvider);
      return videoStream.when(
        data: (data) {
          // data = data as Map<String, dynamic>;
          debugPrint(data['keypoints'].toString());
          return Image.memory(
            data['image'],
            gaplessPlayback: true,
            excludeFromSemantics: true,
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      );
    } else {
      return Text("Start video stream");
    }
  }
}
