import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:providerarchitecturetest/widgets/dropdown.dart';
import 'package:providerarchitecturetest/widgets/filetree.dart';
import 'package:providerarchitecturetest/widgets/mediacontrols.dart';
import 'package:providerarchitecturetest/widgets/videostream.dart';
import 'package:providerarchitecturetest/widgets/welcome.dart';

// class AnalysisScreen extends ConsumerWidget {
//   const AnalysisScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       children: [
//         FileExplorer(
//             directoryPath: r"C:\Users\kiera\OneDrive\Documents\Projects",
//             tilePadding: 0),
//         IconButtonWithAnimatedToolbar(
//           // This is the widget we created
//           onCameraOptionSelected: () {
//             ref.watch(cameraToggleProvider.notifier).toggle();
//           },
//           onCameraOptionDeselected: () {
//             ref.watch(cameraToggleProvider.notifier).toggle();
//           },
//           onGraphOptionSelected: () {},
//           onGraphOptionDeselected: () {},
//         ),
//         VideoStream(),
//       ],
//     );
//   }
// }

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelNotifier = ref.watch(websocketProvider.notifier);
    final projectPath = ref.watch(projectPathProvider);
    debugPrint("Sending data to websocket");
    channelNotifier.send(jsonEncode({
      "isCameraToggle": ref.watch(cameraToggleProvider),
      "isVirtualCanvasToggle": ref.watch(virtualCanvasToggleProvider),
      "fileSelectedPath": ref.watch(fileSelectedProvider),
      "projectPath": ref.watch(projectPathProvider)?.path
    }));
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              FileExplorer(directoryPath: projectPath?.path, tilePadding: 0),
              Expanded(
                child: projectPath != null
                    ? Stack(children: [
                        Center(child: VideoStream()),
                        Column(children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              alignment: Alignment.topRight,
                              child: IconButtonWithAnimatedToolbar(
                                // This is the widget we created
                                onCameraOptionSelected: () {
                                  ref
                                      .watch(cameraToggleProvider.notifier)
                                      .toggle();
                                },
                                onCameraOptionDeselected: () {
                                  ref
                                      .watch(cameraToggleProvider.notifier)
                                      .toggle();
                                },
                                onGraphOptionSelected: () {
                                  ref
                                      .watch(
                                          virtualCanvasToggleProvider.notifier)
                                      .toggle();
                                },
                                onGraphOptionDeselected: () {
                                  ref
                                      .watch(
                                          virtualCanvasToggleProvider.notifier)
                                      .toggle();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.all(20.0),
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                onPressed: () {}, icon: Icon(Icons.fullscreen)),
                          )),
                        ]),
                      ])
                    : Welcome(),
              ),
            ],
          ),
        ),
        MediaControls()
      ],
    );
  }
}
