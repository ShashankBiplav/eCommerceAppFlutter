import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String title;
  ProductDetailScreen({this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
        title: Text(title),
      ),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
