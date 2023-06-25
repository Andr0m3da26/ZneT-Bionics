import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providerarchitecturetest/utilities/providers.dart';

enum FileOptions { openProject, newProject }

class NavbarContainer extends ConsumerWidget {
  FileOptions? selectedMenu;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 100,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.shade600, spreadRadius: 1, blurRadius: 15)
        ]),
        child: Row(
          children: [
            NavbarButton(
              tooltip: "File menu",
              icon: Icons.insert_drive_file,
              onSelected: (dynamic item) {
                debugPrint("File menu selected");
              },
              onOpened: () => debugPrint("File menu opened"),
              menuItems: <PopupMenuEntry<dynamic>>[
                PopupMenuItem<dynamic>(
                  value: FileOptions.newProject,
                  child: Text('New Project'),
                  onTap: () async {
                    // Add your code here
                  },
                ),
                PopupMenuItem<dynamic>(
                  value: FileOptions.openProject,
                  child: Text('Open Project'),
                  onTap: () async {
                    // Add your code here
                  },
                ),
              ],
            ),
            // Consumer<DataModel>(
            //   builder: (context, datamodel, child) {
            //     if (datamodel.activeScreen == ScreenType.videoStream) {
            //       return NavbarButton(
            //         tooltip: "Switch to graphrack",
            //         icon: Icons.show_chart,
            //         onSelected: (dynamic item) =>
            //             debugPrint("Graphrack menu selected"),
            //         onOpened: () {
            //           debugPrint("Switching to graphrack");
            //           DataModel myDataModel =
            //               Provider.of<DataModel>(context, listen: false);
            //           myDataModel.activeScreen = ScreenType.graphRack;
            //         },
            //       );
            //     } else if (datamodel.activeScreen == ScreenType.graphRack) {
            //       return NavbarButton(
            //         tooltip: "Switch to videostream",
            //         icon: Icons.videocam,
            //         onOpened: () {
            //           debugPrint("Switching to videostream");
            //           DataModel myDataModel =
            //               Provider.of<DataModel>(context, listen: false);
            //           myDataModel.activeScreen = ScreenType.videoStream;
            //         },
            //       );
            //     } else {
            //       //Should never happen
            //       return Container();
            //     }
            //   },
            // ),
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
    );
  }

  // Material fileOptionsButton() {
  //   return Material(
  //     child: PopupMenuButton<FileOptions>(
  //       tooltip: "File menu",
  //       child: SizedBox.square(
  //           dimension: 100,
  //           child: InkWell(
  //               hoverColor: Colors.grey, child: Icon(Icons.insert_drive_file))),

  //       // Callback that sets the selected popup menu item.
  //       onSelected: (FileOptions item) {
  //         setState(() {
  //           selectedMenu = item;
  //         });
  //       },
  //       itemBuilder: (BuildContext context) => <PopupMenuEntry<FileOptions>>[
  //         PopupMenuItem<FileOptions>(
  //           value: FileOptions.newProject,
  //           child: Text('New Project'),
  //           onTap: () async {
  //             // String? result = await FilePicker.platform.getDirectoryPath();

  //             // if (result != null) {
  //             //   // Do something with result
  //             //   debugPrint(result);
  //             // } else {
  //             //   // User canceled the picker
  //             //   debugPrint("User cancelled new project");
  //             // }
  //           },
  //         ),
  //         PopupMenuItem<FileOptions>(
  //           value: FileOptions.openProject,
  //           child: Text('Open Project'),
  //           onTap: () async {
  //             // String? result = await FilePicker.platform.getDirectoryPath();

  //             // if (result != null) {
  //             //   // Do something with result
  //             //   debugPrint(result);
  //             // } else {
  //             //   // User canceled the picker
  //             //   debugPrint("User cancelled open project");
  //             // }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

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
        itemBuilder: //if there are menuitems then build, else return null
            (context) {
          if (menuItems != null) {
            return
                //build menuitems
                menuItems!;
          } else {
            return
                //empty List<PopupMenuEntry<dynamic>> Function(BuildContext)
                <PopupMenuEntry<dynamic>>[];
          }
        },
      ),
    );
  }
}

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
