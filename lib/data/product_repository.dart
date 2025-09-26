import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductRepository {
  static Future<List<Product>> loadProducts() async {
    // Load the JSON file
    final String response = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> data = json.decode(response);

    // Convert each JSON object into a Product
    return data.map((json) => Product.fromJson(json)).toList();
  }
}
