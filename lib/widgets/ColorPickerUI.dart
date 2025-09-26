import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class ColorPickerUI extends StatelessWidget {
  final UnityWidgetController unityController;

  const ColorPickerUI({Key? key, required this.unityController})
      : super(key: key);

  // This function sends a message to Unity
  void _changeColor(int index) {
    unityController.postMessage(
      'ARPlacementManager',   // 👈 GameObject name in Unity
      'ChangeFurnitureColor', // 👈 Method in your ARPlacementManager.cs
      index.toString(),       // 👈 Index of material (0,1,2…)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _changeColor(0),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Red"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _changeColor(1),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text("Blue"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _changeColor(2),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
          child: const Text("Wood"),
        ),
      ],
    );
  }
}
