import 'package:flutter/material.dart';

// This is the Welcome widget, which is a StatelessWidget that displays the welcome screen
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    // Build the welcome screen
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      padding: EdgeInsets.all(100),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add a text widget to display a message to the user
            Text(
              'Create a new project or open an existing one to get started.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
