import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/widgets/videoplayer.dart';

// class VideoStream extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bool isCameraToggle = ref.watch(cameraToggleProvider);
//     final bool isVirtualCanvasToggle = ref.watch(virtualCanvasToggleProvider);
//     if (isCameraToggle && isVirtualCanvasToggle) {
//       final videoStream = ref.watch(videoStreamAndVirtualCanvasProvider);
//       return videoStream.when(
//         data: (data) {
//           return Expanded(
//             child: Image.memory(
//               data['image'],
//               gaplessPlayback: true,
//               excludeFromSemantics: true,
//             ),
//           );
//         },
//         loading: () => const CircularProgressIndicator(),
//         error: (err, stack) => Text('Error: $err'),
//       );
//     }

//     if (isCameraToggle && !isVirtualCanvasToggle) {}
//     if (isVirtualCanvasToggle && !isCameraToggle) {
//       final virtualCanvas = ref.watch(virtualCanvasProvider);
//       return virtualCanvas.when(
//         data: (data) {
//           return Expanded(child: Container(child: Text("success")));
//         },
//         loading: () => const CircularProgressIndicator(),
//         error: (err, stack) => Text('Error: $err'),
//       );
//     }
//     return Expanded(
//       child: VideoPlayer(),
//     );
//   }
// }

// if (isCameraToggle) {
//   return camera stream
//   isVirtualCanvasToggle ? return virtual canvas stream (stream) : return nothing
// } else {
//   return video
//   isVirtualCanvasToggle ? return virtual canvas video (future) : return nothing

class VideoStream extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isCameraToggle = ref.watch(cameraToggleProvider);
    final bool isVirtualCanvasToggle = ref.watch(virtualCanvasToggleProvider);
    if (isCameraToggle) {
      return Placeholder();
    } else {
      return Placeholder();
    }
  }
}
