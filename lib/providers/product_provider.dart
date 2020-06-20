import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/http_exception.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   //dummy products added for now
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  ProductProvider(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }
  // getter method to return only favourites

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  //method to fetch products from the server
  Future<void> fetchAndSetProducts() async {
    var url =
        'https://ecommerceappflutter-1feb8.firebaseio.com/products.json?auth=$authToken'; //firebase specific
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://ecommerceappflutter-1feb8.firebaseio.com/userFavourites/$userId.json/?auth=$authToken';
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavourite:
                favouriteData == null ? false : favouriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://ecommerceappflutter-1feb8.firebaseio.com/products.json?auth=$authToken'; //firebase specific
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          // 'isFavourite': product.isFavourite,
        }),
      );
      print(json.decode(response.body));
      final newProduct = Product(
        description: product.description,
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)[
            'name'], // assingning the id that is given to the obejct by firebase
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // to add items at the begenning of the list
      notifyListeners();
      // .then((response) {
    } // then returns a future
    catch (error) {
      print(error);
      throw error;
    }

    // }).catchError((error) {
    // print(error);
    // throw error;
    // });
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url =
          'https://ecommerceappflutter-1feb8.firebaseio.com/products/$id.json?auth=$authToken'; //firebase specific
      //TODO: add try catch
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://ecommerceappflutter-1feb8.firebaseio.com/products/$id.json?auth=$authToken';
    final existingproductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingproductIndex];
    final response = await http.delete(url);
    _items.removeAt(existingproductIndex);
    notifyListeners();
    if (response.statusCode >= 400) {
      _items.insert(existingproductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
