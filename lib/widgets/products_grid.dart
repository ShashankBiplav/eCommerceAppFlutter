import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';
import '../providers/product_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavourites;
  ProductsGrid({this.showFavourites});
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    //using getter method defined in product_provider.dart to fetch all products
    final products = showFavourites? productData.favouriteItems :productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      //setting up a provider here so that we can listen inside ProductItem()  if a product isFAvourite or not.
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value:products[i] ,
        // create: (ctx) => products[i],
        child: ProductItem(
            // imageUrl: products[i].imageUrl,
            // id: products[i].id,
            // title: products[i].title,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
