
import 'package:fakestoreapi/Controller/homeController.dart';
import 'package:fakestoreapi/View/deatailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsView extends StatefulWidget {
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

 void _showCreateProductDialog() {
  String title = '', description = '', category = '';
  double price = 0.0;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Create Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => title = value,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              onChanged: (value) => description = value,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              onChanged: (value) => price = double.tryParse(value) ?? 0.0,
              decoration: InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              onChanged: (value) => category = value,
              decoration: InputDecoration(labelText: "Category"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await Provider.of<ProductProvider>(context, listen: false)
                  .createProduct(title, description, price, category);

              Navigator.of(context).pop();

              // Show a success message upon product creation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Product successfully added!")),
              );
            },
            child: Text("Submit"),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Center(child: Text("Products")),backgroundColor: Colors.grey,),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.products.isEmpty) {
            return Center(child: Text("No products available"));
          }

          return GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsView(product: product),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await provider.deleteProduct(product.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Product deleted successfully")),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.title,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "\$${product.price}",
                              style: TextStyle(fontSize: 14, color: Colors.green),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateProductDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
