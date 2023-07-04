import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamDisplay extends ConsumerWidget {
  const StreamDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isVirtualCanvasToggle = ref.watch(virtualCanvasToggleProvider);
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
                  : Container(),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
