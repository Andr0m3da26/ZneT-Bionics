import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/screens/analysisscreen.dart';
import 'package:providerarchitecturetest/screens/graphrackscreen.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/widgets/navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:window_manager/window_manager.dart';

/// Kieran Chao | ZneT Bionics
///
/// Project structure:
///
/// Flutter applications are built using widgets, which are the building blocks of the UI.
/// All widgets are defined in the lib\widgets folder.
///
/// The logic and state of this project is managed using the Riverpod package, which is a state management library.
/// The Riverpod package uses providers to manage state, which are objects that can be listened to and read from anywhere in the app.
/// The providers are defined in the lib\utilities\providers.dart file.
///
/// A group of widgets that are related to each other are defined in their own screen.
/// These screens are defined in the lib\screens folder.
///
///
/// Main.dart file:
///
/// Running this file will run the app.

void main() async {
  // Ensure that the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the window manager
  await windowManager.ensureInitialized();

  // Define the window options
  WindowOptions windowOptions = const WindowOptions(
    title: "ZneT Bionics",
    minimumSize: Size(576, 740),
  );

  // Show the window
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Initialize the DartVLC library
  DartVLC.initialize();

  // Run the app
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the selected screen index from the provider
    final int _selectedIndex = ref.watch(screenIndexProvider);
    // Build the app
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            textTheme:
                GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)),
        home: Scaffold(
          body: Column(children: [
            // Build the navigation bar
            NavbarContainer(),
            // Build the selected screen
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
