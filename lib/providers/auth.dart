import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCzuDoZGrATzjxyUkQxTWDff81gdujHp84';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if ( responseData['error']!= null) {
        throw HttpException(responseData['error']['message']);
      }
      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    // const url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCzuDoZGrATzjxyUkQxTWDff81gdujHp84';

    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    // const url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCzuDoZGrATzjxyUkQxTWDff81gdujHp84';

    return _authenticate(email, password, 'signInWithPassword');
  }
}
