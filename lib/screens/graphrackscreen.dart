import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/widgets/graphdisplay.dart';
import 'package:providerarchitecturetest/widgets/graphrack.dart';

// This is the GraphRackScreen widget, which is a StatelessWidget that displays the graph rack screen
class GraphRackScreen extends StatelessWidget {
  const GraphRackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Build the graph rack screen
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Build the graph display
        Expanded(child: GraphDisplay()),
        // Build the graph rack
        GraphRack(),
      ],
    );
  }
}
