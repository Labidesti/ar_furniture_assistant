import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import '../models/product.dart';
import '../widgets/ColorPickerUI.dart'; // 👈 import our ColorPickerUI

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  UnityWidgetController? _unityController;

  void _onUnityCreated(UnityWidgetController controller) {
    _unityController = controller;
  }

  void _openARView() {
    if (_unityController != null) {
      _unityController!.postMessage(
        "ARPlacementManager", // 👈 Unity GameObject
        "LoadModel",          // 👈 Method in ARPlacementManager.cs
        widget.product.unityModel, // 👈 the prefab name (from product.dart)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: Column(
        children: [
          // Product image
          Image.network(widget.product.image,
              height: 200, width: double.infinity, fit: BoxFit.cover),

          const SizedBox(height: 10),

          // Product details
          Text(widget.product.name,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          Text("\$${widget.product.price}",
              style: const TextStyle(fontSize: 18, color: Colors.green)),

          const SizedBox(height: 20),

          // 🔘 Button to open AR model
          ElevatedButton(
            onPressed: _openARView,
            child: const Text("View in AR"),
          ),

          const SizedBox(height: 20),

          // 🎨 Color Picker UI
          if (_unityController != null)
            ColorPickerUI(unityController: _unityController!),

          // Expanded AR View
          Expanded(
            child: UnityWidget(
              onUnityCreated: _onUnityCreated,
            ),
          ),
        ],
      ),
    );
  }
}
