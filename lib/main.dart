import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/screens/analysisscreen.dart';
import 'package:providerarchitecturetest/screens/graphrackscreen.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/widgets/navbar.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    title: "ZneT Bionics",
    minimumSize: Size(800, 600),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  DartVLC.initialize();
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
    final int _selectedIndex = ref.watch(screenIndexProvider);

    return MaterialApp(
        home: Scaffold(
      body: Column(children: [
        NavbarContainer(),
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: const [
              AnalysisScreen(),
              GraphRackScreen(),
            ],
          ),
        ),
      ]),
    ));
  }
}
