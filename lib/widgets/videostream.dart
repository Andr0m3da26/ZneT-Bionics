import 'package:providerarchitecturetest/widgets/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This is the VideoStream widget, which is a ConsumerWidget that displays the video stream
class VideoStream extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the isCameraToggleProvider from the providers file
    final bool isCameraToggle = ref.watch(cameraToggleProvider);

    // Get the isVirtualCanvasToggleProvider from the providers file
    final bool isVirtualCanvasToggle = ref.watch(virtualCanvasToggleProvider);
    // Get the websocketProvider from the providers file
    final channel = ref.watch(websocketProvider);

    if (isCameraToggle) {
      final videoStream = ref.watch(videoStreamAndVirtualCanvasProvider);
      return videoStream.when(
        // If the video stream is available, then display it
        data: (data) {
          return Row(
            children: [
              Expanded(
                child: Image.memory(
                  data['camdata'],
                  gaplessPlayback: true,
                  excludeFromSemantics: true,
                ),
              ),
              // If the virtual canvas is toggled, then display it
              isVirtualCanvasToggle
                  ? Expanded(
                      child: Image.memory(
                        data['vcdata'],
                        gaplessPlayback: true,
                        excludeFromSemantics: true,
                      ),
                    )
                  : Container()
            ],
          );
        },
        // If the virtual canvas is still loading, display a loading indicator
        loading: () => const CircularProgressIndicator(),
        // If there's an error loading the virtual canvas, display an error message
        error: (err, stack) => Text('Error: $err'),
      );
      // If the virtual canvas toggle is off, display only the video player
    } else {
      final virtualCanvas = ref.watch(virtualCanvasProvider);
      final fileSelected = ref.watch(fileSelectedProvider);
      return Row(
        children: [
          Expanded(child: VideoPlayer()),
          isVirtualCanvasToggle
              ? virtualCanvas.when(
                  data: (data) {
                    return Container(child: Text("success: $fileSelected"));
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) {
                    debugPrint(stack.toString());
                    return Text('Error: $err');
                  },
                  skipLoadingOnRefresh: false)
              : Container(
                  decoration: BoxDecoration(color: Colors.grey[600]),
                ),
        ],
      );
    }
  }
}
