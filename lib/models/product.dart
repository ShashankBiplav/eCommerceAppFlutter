import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void _setFavValue(bool newValue){
      isFavourite = newValue;
      notifyListeners();
  }
  // Apply optimistic updating for smooth UI performance
  Future<void> toggleFavouriteStatus(String authToken) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://ecommerceappflutter-1feb8.firebaseio.com/products/$id.json?auth=$authToken';
    try {
      final response = await http.patch(
        url,
        body: json.encode({'isFavourite': isFavourite}),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
