import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class ARViewScreen extends StatefulWidget {
  final String? modelName; // Pass model from catalog
  const ARViewScreen({super.key, this.modelName});

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen> {
  UnityWidgetController? _unityController;

  void onUnityCreated(UnityWidgetController controller) {
    _unityController = controller;

    // Auto-load model if passed
    if (widget.modelName != null) {
      loadModel(widget.modelName!);
    }
  }

  // Flutter → Unity: load model
  void loadModel(String modelName) {
    _unityController?.postMessage(
      'ARPlacementManager', // Unity GameObject
      'LoadModel',          // Method in ARPlacementManager.cs
      modelName,            // e.g., "hamiltonsofa"
    );
  }

  // Flutter → Unity: change color
  void changeColor(int index) {
    _unityController?.postMessage(
      'ARPlacementManager',
      'ChangeFurnitureColor',
      index.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AR Furniture Preview"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Stack(
        children: [
          // Unity AR Scene
          UnityWidget(
            onUnityCreated: onUnityCreated,
            useAndroidViewSurface: true, // ✅ hybrid composition
          ),

          // Flutter overlay (UI controls)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => changeColor(0),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[200]),
                  child: const Text("Beige"),
                ),
                ElevatedButton(
                  onPressed: () => changeColor(1),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text("Gray"),
                ),
                ElevatedButton(
                  onPressed: () => changeColor(2),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Blue"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
