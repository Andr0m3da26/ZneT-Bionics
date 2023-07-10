//create a pop up widget that asks the user to enter a project name

import 'package:flutter/material.dart';
import 'dart:io';

Future<String?> dialogBuilder(BuildContext context, strFolderDir) async {
  String projectName = "";
  return showDialog<String?>(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Project'),
          content: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onFieldSubmitted: (value) {
              Navigator.of(context).pop(value);
            },
            onChanged: (value) {
              projectName = value;
            },
            decoration: InputDecoration(hintText: "Enter Project Name"),
            validator: (String? value) {
              //check if the project name already exists
              //if it does, return an error message
              // debugPrint(value);
              if (value == null || value.isEmpty) {
                // debugPrint("empty");
                return 'Please enter a project name';
              }
              if (Directory("$strFolderDir\\$value").existsSync()) {
                // debugPrint("exists");
                return 'Project already exists';
              }
              // debugPrint("valid");
              return null;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(projectName);
              },
              child: const Text('Create'),
            ),
          ],
        );
      });
}

// Future<void> dialogBuilder(BuildContext context) {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Basic dialog title'),
//         content: const Text(
//           'A dialog is a type of modal window that\n'
//           'appears in front of app content to\n'
//           'provide critical information, or prompt\n'
//           'for a decision to be made.',
//         ),
//         actions: <Widget>[
//           TextButton(
//             style: TextButton.styleFrom(
//               textStyle: Theme.of(context).textTheme.labelLarge,
//             ),
//             child: const Text('Disable'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           TextButton(
//             style: TextButton.styleFrom(
//               textStyle: Theme.of(context).textTheme.labelLarge,
//             ),
//             child: const Text('Enable'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
