import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';

class MediaControls extends ConsumerWidget {
  const MediaControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isRecordingToggle = ref.watch(recordingToggleProvider);
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child:
            //  IconButton(
            //     onPressed: () {
            //       ref.watch(recordingToggleProvider.notifier).toggle();
            //     },
            //     icon: Icon(Icons.fiber_manual_record),
            //     selectedIcon: Icon(Icons.stop_circle))
            IconButton(
          onPressed: () {
            ref.watch(recordingToggleProvider.notifier).toggle();
          },
          isSelected: isRecordingToggle,
          icon: Icon(Icons.fiber_manual_record),
          selectedIcon: Icon(Icons.stop_circle),
        ),
      ),
    );
  }
}
