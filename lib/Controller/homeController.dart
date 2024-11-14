

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../Model/dataModel.dart';

class ProductProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final String _url = "https://fakestoreapi.com/products";
  
  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _dio.get(_url);
      if (response.statusCode == 200) {
        _products = (response.data as List)
            .map((productJson) => Product.fromJson(productJson))
            .toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await _dio.delete("$_url/$id");
      if (response.statusCode == 200) {
        _products.removeWhere((product) => product.id == id);
        notifyListeners();
      } else {
        throw Exception("Failed to delete product");
      }
    } catch (e) {
      throw Exception("Error deleting product: $e");
    }
  }
Future<void> createProduct(
    String title, String description, double price, String category) async {
  try {
    final response = await _dio.post(
      _url,
      data: {
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": "https://i.pravatar.cc" // Placeholder image
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Parse the response to create a new Product instance
      Product newProduct = Product.fromJson(response.data);
      // Add the new product to the list and notify listeners
      _products.add(newProduct);
      notifyListeners();
    } else {
      throw Exception("Failed to create product: ${response.statusMessage}");
    }
  } catch (e) {
    print("Error creating product: $e");
    throw Exception("Error creating product: $e");
  }
}

}

