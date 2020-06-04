import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

enum FilterOptions{
  FAVOURITES,
  ALL,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showonlyFavourites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
             setState(() {
                if(selectedValue == FilterOptions.FAVOURITES){
                _showonlyFavourites =true;
              }
              else{
                _showonlyFavourites =false;
              }
             });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('My Favourites'),
                value: FilterOptions.FAVOURITES,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.ALL,
              ),
            ],
          ),
        ],
      ),
      body: ProductsGrid(showFavourites:_showonlyFavourites),
    );
  }
}
