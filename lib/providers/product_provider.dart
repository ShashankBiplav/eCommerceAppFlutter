import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      //dummy products added for now
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }
  // getter method to return only favourites

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Future<void> addProduct(Product product) {
    const url =
        'https://ecommerceappflutter-1feb8.firebaseio.com/products.json'; //firebase specific
    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavourite': product.isFavourite,
            }))
        .then((response) { // then returns a future
          print(json.decode(response.body));
      final newProduct = Product(
        description: product.description,
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],// assingning the id that is given to the obejct by firebase
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // to add items at the begenning of the list
      notifyListeners();
    }).catchError((error){
      print(error);
      throw error;
    });
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void updateProduct(String id, Product newProduct) {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
