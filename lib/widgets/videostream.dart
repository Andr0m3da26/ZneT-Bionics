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
    final channel = ref.watch(websocketProvider);
    // final channelNotifier = ref.watch(websocketProvider.notifier);
    // channelNotifier.send(
    //       jsonEncode({"isCameraToggle": isCameraToggle, "isVirtualCanvasToggle": isVirtualCanvasToggle}));
    if (isCameraToggle) {
      final videoStream = ref.watch(videoStreamAndVirtualCanvasProvider);
      return videoStream.when(
        data: (data) {
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Image.memory(
                    data['camdata'],
                    gaplessPlayback: true,
                    excludeFromSemantics: true,
                  ),
                ),
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
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      );
    }

    // if (isCameraToggle && !isVirtualCanvasToggle) {
    //   channelNotifier.send(
    //       jsonEncode({"isCameraToggle": true, "isVirtualCanvasToggle": false}));
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
      final virtualCanvas = ref.watch(virtualCanvasProvider);
      final fileSelected = ref.watch(fileSelectedProvider);
      return virtualCanvas.when(
          data: (data) {
            return Expanded(
                child: Container(child: Text("success: $fileSelected")));
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) {
            debugPrint(stack.toString());
            return Text('Error: $err');
          },
          skipLoadingOnRefresh: false);
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[600]),
      ),
    );
  }
}
