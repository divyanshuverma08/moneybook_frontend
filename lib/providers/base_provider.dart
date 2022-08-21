import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './book_provider.dart';

class BaseProvider with ChangeNotifier {
  List<BookProvider> _books = [];
  bool userInsideApp = false;

  List<BookProvider> get listBooks {
    return [..._books];
  }

  final String? _token;
  final String? _userId;

  BaseProvider(this._token, this._userId);

  Future<void> getAllBooks() async {
    try {
      final url = Uri.parse("${dotenv.env['API_URL']}/api/v1/book/getbook");

      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Charset': 'utf-8',
        'api-key': '${dotenv.env['API_KEY']}',
        'Authorization': 'Bearer ${_token as String}'
      };

      final response = await http.get(url, headers: headers);
      print(response.body);

      final responseData = jsonDecode(response.body);

      final extractedData = responseData["data"] as List;

      List<BookProvider> loadedBooks = [];

      for (int i = 0; i < extractedData.length; i++) {
        loadedBooks.add(BookProvider(
            token: _token as String,
            userId: _userId as String,
            bookId: extractedData[i]['_id'] as String,
            bookName: extractedData[i]['bookName'] as String,
            total: extractedData[i]['total'].toDouble(),
            cashIn: extractedData[i]['cashIn'].toDouble(),
            cashOut: extractedData[i]['cashOut'].toDouble()));
      }

      _books = loadedBooks;
      notifyListeners();
    } catch (e) {
      rethrow;
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

      final newBook = BookProvider(
          token: _token as String,
          userId: _userId as String,
          bookId: responseData['data']['_id'] as String,
          bookName: responseData['data']['bookName'] as String,
          total: responseData['data']['total'].toDouble(),
          cashIn: responseData['data']['cashIn'].toDouble(),
          cashOut: responseData['data']['cashOut'].toDouble());
      _books.add(newBook);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      final url = Uri.parse("${dotenv.env['API_URL']}/api/v1/book/delete");

      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Charset': 'utf-8',
        'api-key': '${dotenv.env['API_KEY']}',
        'Authorization': 'Bearer ${_token as String}'
      };

      final response = await http.delete(url,
          body: json.encode(
            {'id': bookId},
          ),
          headers: headers);

      final responseData = json.decode(response.body);

      _books.removeWhere((book) => book.bookId == bookId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
