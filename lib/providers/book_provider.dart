import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookProvider with ChangeNotifier {
  final String bookName;
  final String bookId;
  double total;
  double cashIn;
  double cashOut;

  BookProvider(
      {required this.bookId,
      required this.bookName,
      required this.total,
      required this.cashIn,
      required this.cashOut});
}
