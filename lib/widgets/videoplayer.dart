import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';

// This is the VideoPlayer widget, which is a ConsumerWidget that displays the video player
class VideoPlayer extends ConsumerWidget {
  const VideoPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build the video player
    return ref.watch(videoPlayerProvider);
  }
}
