import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:providerarchitecturetest/widgets/dropdown.dart';
import 'package:providerarchitecturetest/widgets/filetree.dart';
import 'package:providerarchitecturetest/widgets/videostream.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          height: 500,
          child: FileExplorer(
              directoryPath: r"C:\Users\kiera\OneDrive\Documents\Projects",
              tilePadding: 0),
        ),
        IconButtonWithAnimatedToolbar(
          // This is the widget we created
          onCameraOptionSelected: () {
            ref.watch(cameraToggleProvider.notifier).toggle();
          },
          onCameraOptionDeselected: () {
            ref.watch(cameraToggleProvider.notifier).toggle();
          },
          onGraphOptionSelected: () {},
          onGraphOptionDeselected: () {},
        ),
        VideoStream(),
      ],
    );
  }
}
