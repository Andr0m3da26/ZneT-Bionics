import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:dart_vlc/dart_vlc.dart';

class VideoPlayer extends ConsumerWidget {
  const VideoPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(videoPlayerProvider);
  }
}
