

import 'package:fakestoreapi/Controller/homeController.dart';
import 'package:fakestoreapi/View/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake Store Products',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProductsView(),
    );
  }
}
