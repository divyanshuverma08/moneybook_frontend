import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _tokenExpiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    if (kDebugMode) {
      print('get(): isAuth - ' + token.toString());
    }
    return token != null;
  }

  String? get token {
    if (_tokenExpiryDate != null &&
        _tokenExpiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  //auth service signup
  Future<void> signUp(
      String email, String password, String name, String phone) async {
    final url = Uri.parse("${dotenv.env['API_URL']}/api/v1/user/register");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Charset': 'utf-8',
      'api-key': '${dotenv.env['API_KEY']}'
    };

    try {
      final response = await http.post(url,
          body: json.encode(
            {
              "name": name,
              "email": email,
              "password": password,
              "phone": phone
            },
          ),
          headers: headers);

      final responseData = json.decode(response.body);
      print(responseData);

      signIn(email, password, true);
    } catch (error) {
      throw error;
    }
  }

  Future<void> createBook(String bookName) async {
    try {
      final url = Uri.parse("${dotenv.env['API_URL']}/api/v1/book/create");

      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Charset': 'utf-8',
        'api-key': '${dotenv.env['API_KEY']}',
        'Authorization': 'Bearer ${_token as String}'
      };

      final response = await http.post(url,
          body: json.encode(
            {'bookName': bookName},
          ),
          headers: headers);

      final responseData = json.decode(response.body);
      print(responseData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password, bool newUser) async {
    final url = Uri.parse("${dotenv.env['API_URL']}/api/v1/user/login");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Charset': 'utf-8',
      'api-key': '${dotenv.env['API_KEY']}'
    };

    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'email': email,
              'password': password,
            },
          ),
          headers: headers);

      final responseData = json.decode(response.body);

      // if (responseData['error'] != null) {
      //   throw HttpException(responseData['error']['message']);
      // }
      if (kDebugMode) {
        print(
            '_authenticate(): response.body - ${json.decode(response.body).toString()}');
      }
      _token = responseData['data']['jwtToken'];
      if (kDebugMode) {
        print('_authenticate(): _token - ${_token.toString()}');
      }
      _userId = responseData['data']['emailId'];
      if (kDebugMode) {
        print('_authenticate(): _userId - ${_userId.toString()}');
      }
      // responseData['tokenExpiry']
      _tokenExpiryDate = DateTime.now().add(
        const Duration(
          seconds: 36000,
        ),
      );
      if (kDebugMode) {
        print(
            '_authenticate(): _tokenExpiryDate - ${_tokenExpiryDate.toString()}');
      }
      if (kDebugMode) {
        print('_authenticate(): isAuth - ${isAuth.toString()}');
      }

      if (newUser) {
        await createBook("New Book");
      }

      _autoLogout();

      notifyListeners();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(
        {
          'token': _token,
          'userId': _userId,
          'tokenExpiryDate': _tokenExpiryDate!.toIso8601String(),
        },
      );
      if (kDebugMode) {
        print(
            '_authenticate(): userData - ${json.decode(userData).toString()}');
      }
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      if (kDebugMode) {
        print('tryAutoLogin(): No user data found in shared preferences!');
      }
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!);
    final expiryDate =
        DateTime.parse(extractedUserData['tokenExpiryDate'].toString());
    if (expiryDate.isBefore(DateTime.now())) {
      if (kDebugMode) {
        print('tryAutoLogin(): Token expired as per shared preferences!');
      }
      return false;
    }
    _token = extractedUserData['token'].toString();
    if (kDebugMode) {
      print('autoLogin(): _token - ' + _token.toString());
    }
    _userId = extractedUserData['userId'].toString();
    if (kDebugMode) {
      print('autoLogin(): _userId - ' + _userId.toString());
    }
    _tokenExpiryDate = expiryDate;
    if (kDebugMode) {
      print('autoLogin(): _tokenExpiryDate - ' + expiryDate.toString());
    }

    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _tokenExpiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    if (kDebugMode) {
      print('logout(): _token - ' + _token.toString());
    }
    if (kDebugMode) {
      print('logout(): _userId - ' + _userId.toString());
    }
    if (kDebugMode) {
      print('logout(): _tokenExpiryDate - ' + _tokenExpiryDate.toString());
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _tokenExpiryDate!
        .difference(
          DateTime.now(),
        )
        .inSeconds;
    _authTimer = Timer(
        Duration(
          seconds: timeToExpiry,
        ),
        logout);
  }
}
