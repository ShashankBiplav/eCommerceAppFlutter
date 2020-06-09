import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/navigation_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //TODO: navigate to an new screen to add products
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_, i) => UserProductItem(
            title: productsData.items[i].title,
            imageUrl: productsData.items[i].imageUrl,
          ),
          itemCount: productsData.items.length,
        ),
      ),  
      drawer: NavigationDrawer(),
    );
  }
}
