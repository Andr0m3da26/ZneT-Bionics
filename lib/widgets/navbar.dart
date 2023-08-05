import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';

// This is the NavbarContainer widget, which is a ConsumerWidget that displays the navbar
class NavbarContainer extends ConsumerWidget {
  ProjectOptions? selectedMenu;

  NavbarContainer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the projectOptionsHandler notifier from the providers file
    final fileOptions = ref.watch(projectOptionsHandler.notifier);
    // Build the NavbarContainer widget
    return SizedBox(
      height: 100,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.shade600, spreadRadius: 1, blurRadius: 15)
        ]),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Build a NavbarButton for the file menu
                  NavbarButton(
                    tooltip: "File menu",
                    icon: Icons.insert_drive_file,
                    onSelected: (item) {
                      // When a menu item is selected, handle the selection using the fileOptions notifier
                      fileOptions.handleSelection(item, context);

                      debugPrint("File menu selected");
                    },
                    onOpened: () => debugPrint("File menu opened"),
                    menuItems: <PopupMenuEntry<dynamic>>[
                      // Build 'new project' menu item
                      PopupMenuItem<dynamic>(
                        value: ProjectOptions.newProject,
                        child: const Text('New Project...'),
                        onTap: () async {},
                      ),
                      // Build 'open project' menu item
                      PopupMenuItem<dynamic>(
                        value: ProjectOptions.openProject,
                        child: const Text('Open Project...'),
                        onTap: () async {},
                      ),
                    ],
                  ),
                  // Build a NavbarButton to toggle between the analysis screen and the graph rack screen
                  NavbarToggleButton(
                    icon1: Icons.show_chart,
                    icon2: Icons.videocam,
                    onIcon1pressed: () {
                      ref.watch(screenIndexProvider.notifier).changeScreen(1);
                    },
                    onIcon2pressed: () {
                      ref.watch(screenIndexProvider.notifier).changeScreen(0);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Build settings menu
                  NavbarButton(
                    tooltip: "Settings",
                    icon: Icons.settings,
                    onSelected: (dynamic item) {
                      debugPrint("Settings menu selected");
                    },
                    onOpened: () => debugPrint("Settings menu opened"),
                    menuItems: <PopupMenuEntry<dynamic>>[
                      // Build 'preferences' menu item
                      PopupMenuItem<dynamic>(
                        value: SettingsOptions.preferences,
                        child: const Text('Preferences'),
                        onTap: () async {
                          debugPrint("Preferences menu item selected");
                          // TO DO
                        },
                      ),
                      // Build 'help' menu item
                      PopupMenuItem<dynamic>(
                        value: SettingsOptions.help,
                        child: const Text('Help'),
                        onTap: () async {
                          debugPrint("Help menu item selected");
                          // TO DO
                        },
                      ),
                      // Build 'exit' menu item
                      PopupMenuItem<dynamic>(
                        value: SettingsOptions.exit,
                        child: const Text('Exit'),
                        onTap: () async {
                          exit(0);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// This is the NavbarButton widget, which is a StatelessWidget that displays a button in the navbar
class NavbarButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Function(dynamic)? onSelected;
  final Function()? onOpened;
  final List<PopupMenuEntry<dynamic>>? menuItems;

  const NavbarButton({
    Key? key,
    required this.tooltip,
    required this.icon,
    this.onSelected,
    this.onOpened,
    this.menuItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build the NavbarButton widget
    return Material(
      child: PopupMenuButton(
        tooltip: tooltip,
        child: SizedBox.square(
          dimension: 100,
          child: InkWell(
            hoverColor: Colors.grey,
            child: Icon(icon),
          ),
        ),
        onSelected: onSelected,
        onOpened: onOpened,
        itemBuilder: (context) {
          if (menuItems != null) {
            return menuItems!;
          } else {
            return <PopupMenuEntry<dynamic>>[];
          }
        },
      ),
    );
  }
}

// This is the NavbarToggleButton widget, which is a StatefulWidget that displays a toggle button in the navbar
class NavbarToggleButton extends StatefulWidget {
  final IconData icon1;
  final IconData icon2;
  final Function() onIcon1pressed;
  final Function() onIcon2pressed;

  const NavbarToggleButton({
    Key? key,
    required this.icon1,
    required this.icon2,
    required this.onIcon1pressed,
    required this.onIcon2pressed,
  }) : super(key: key);

  @override
  State<NavbarToggleButton> createState() => _NavbarToggleButtonState();
}

class _NavbarToggleButtonState extends State<NavbarToggleButton> {
  late Icon activeIcon;

  @override
  void initState() {
    super.initState();
    activeIcon = Icon(widget.icon1);
  }

  @override
  Widget build(BuildContext context) {
    // Build the NavbarToggleButton widget
    return MaterialButton(
      child: SizedBox(
        height: 100,
        width: 85,
        child: InkWell(
          hoverColor: Colors.grey,
          child: activeIcon,
        ),
      ),
      onPressed: () {
        if (activeIcon.icon == widget.icon1) {
          setState(() {
            activeIcon = Icon(widget.icon2);
          });
          widget.onIcon1pressed();
        } else if (activeIcon.icon == widget.icon2) {
          setState(() {
            activeIcon = Icon(widget.icon1);
          });
          widget.onIcon2pressed();
        }
      },
    );
  }
}
