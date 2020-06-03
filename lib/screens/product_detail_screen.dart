import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  // final String title;
  // ProductDetailScreen({this.title});
  @override
  Widget build(BuildContext context) {
   final productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
        title: Text(productId),
      ),
      body: Center(
        child: Text(productId),
      ),
    );
  }
}
