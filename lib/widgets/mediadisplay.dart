import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/widgets/streamdisplay.dart';

class VideoStream extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isCameraToggle = ref.watch(cameraToggleProvider);
    final bool isVirtualCanvasToggle = ref.watch(virtualCanvasToggleProvider);
    final channel = ref.watch(websocketProvider);
    final channelNotifier = ref.watch(websocketProvider.notifier);
    channelNotifier.send(jsonEncode({
      "isCameraToggle": isCameraToggle,
      "isVirtualCanvasToggle": isVirtualCanvasToggle
    }));
    if (isCameraToggle) {
      StreamDisplay();
    }

    // if (isCameraToggle && !isVirtualCanvasToggle) {
    //   final videoStream = ref.watch(videoStreamAndVirtualCanvasProvider);
    //   return videoStream.when(
    //     data: (data) {
    //       return Expanded(
    //         child: Image.memory(
    //           data['camdata'],
    //           gaplessPlayback: true,
    //           excludeFromSemantics: true,
    //         ),
    //       );
    //     },
    //     loading: () => const CircularProgressIndicator(),
    //     error: (err, stack) => Text('Error: $err'),
    //   );
    // }
    if (isVirtualCanvasToggle && !isCameraToggle) {
      // final virtualCanvas = ref.watch(virtualCanvasProvider);
      // return virtualCanvas.when(
      //   data: (data) {
      //     return Expanded(child: Container(child: Text("success")));
      //   },
      //   loading: () => const CircularProgressIndicator(),
      //   error: (err, stack) => Text('Error: $err'),
      // );
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[600]),
      ),
    );
  }
}
