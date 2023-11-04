import 'package:flutter/material.dart';

class ManualController extends StatefulWidget {
  const ManualController({super.key});

  @override
  State<ManualController> createState() => _ManualControllerState();
}

class _ManualControllerState extends State<ManualController> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text("Manual SOS"));
  }
}
