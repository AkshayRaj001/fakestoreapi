// product_details_view.dart

import 'package:flutter/material.dart';

import '../Model/dataModel.dart';

class ProductDetailsView extends StatelessWidget {
  final Product product;

  ProductDetailsView({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                product.image,
                height: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                product.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Price: \$${product.price}",
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              SizedBox(height: 8),
              Text(
                "Category: ${product.description}",
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 16),
              Text(
                product.description,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
