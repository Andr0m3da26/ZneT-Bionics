import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/widgets/dropdown.dart';
import 'package:providerarchitecturetest/widgets/filetree.dart';
import 'package:providerarchitecturetest/widgets/mediacontrols.dart';
import 'package:providerarchitecturetest/widgets/videostream.dart';
import 'package:providerarchitecturetest/widgets/welcome.dart';

// This is the AnalysisScreen widget, which is a ConsumerWidget that displays the analysis screen
class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the websocket notifier from the provider
    final channelNotifier = ref.watch(websocketProvider.notifier);
    // Get the project path from the provider
    final projectPath = ref.watch(projectPathProvider);
    // Send data to the websocket
    debugPrint("Sending data to websocket");
    channelNotifier.send(jsonEncode({
      "isCameraToggle": ref.watch(cameraToggleProvider),
      "isVirtualCanvasToggle": ref.watch(virtualCanvasToggleProvider),
      "isRecording": ref.watch(recordingToggleProvider),
      "fileSelectedPath": ref.watch(fileSelectedProvider),
      "projectPath": ref.watch(projectPathProvider)?.path
    }));

    // Build the analysis screen
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              // Build the file explorer
              FileExplorer(directoryPath: projectPath?.path, tilePadding: 0),
              Expanded(
                child: projectPath != null
                    ? Stack(children: [
                        // Build the video stream
                        Center(child: VideoStream()),
                        Column(children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              alignment: Alignment.topRight,
                              child: IconButtonWithAnimatedToolbar(
                                // Build dropdown menu
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
                          // Build the fullscreen button
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.all(20.0),
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                onPressed: () {}, icon: Icon(Icons.fullscreen)),
                          )),
                        ]),
                      ])
                    // Build the welcome message
                    : Welcome(),
              ),
            ],
          ),
        ),
        // Build the media controls
        MediaControls()
      ],
    );
  }
}
