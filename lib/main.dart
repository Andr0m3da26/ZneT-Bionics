import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:providerarchitecturetest/widgets/dropdown.dart';
import 'package:providerarchitecturetest/widgets/videostream.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.

void main() {
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final String value = ref.watch(helloWorldProvider);
    // final bool isCameraToggle = ref.watch(cameraToggleProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Row(
          children: [
            IconButtonWithAnimatedToolbar(
              // This is the widget we created
              onCameraOptionSelected: () {
                ref.read(cameraToggleProvider.notifier).toggle();
              },
              onCameraOptionDeselected: () {
                ref.read(cameraToggleProvider.notifier).toggle();
              },
              onGraphOptionSelected: () {},
              onGraphOptionDeselected: () {},
            ),
            VideoStream(),
          ],
        ),
      ),
    );
  }
}
