import 'package:flutter/material.dart';
import 'package:providerarchitecturetest/widgets/graphdisplay.dart';
import 'package:providerarchitecturetest/widgets/graphrack.dart';

class GraphRackScreen extends StatelessWidget {
  const GraphRackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: GraphDisplay()),
        GraphRack(),
      ],
    );
  }
}
