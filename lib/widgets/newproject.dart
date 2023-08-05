import 'package:flutter/material.dart';
import 'dart:io';

// This is the dialogBuilder function, which displays a dialog for creating a new project
Future<String?> dialogBuilder(BuildContext context, strFolderDir) async {
  String projectName = "";
  return showDialog<String?>(
      context: context,
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
            // The validator receives the text that the user has entered. If the text is empty or the project name already exists, then inform the user with the given message
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a project name';
              }
              if (Directory("$strFolderDir\\$value").existsSync()) {
                return 'Project already exists';
              }

              return null;
            },
          ),
          actions: <Widget>[
            // Add a "Cancel" button to the dialog
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            // Add a "Create" button to the dialog
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
