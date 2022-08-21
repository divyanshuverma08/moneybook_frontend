import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum TransactionType { cashIn, cashOut }

class TransactionProvider with ChangeNotifier {
  final String details;
  double amount;
  TransactionType type;
  String bookId;

  TransactionProvider(
      {required this.details,
      required this.amount,
      required this.type,
      required this.bookId});
}
