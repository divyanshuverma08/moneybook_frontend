import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './transaction_provider.dart';

class BookProvider with ChangeNotifier {
  final String bookName;
  final String bookId;
  double total;
  double cashIn;
  double cashOut;
  List<TransactionProvider> _transactions = [];
  final String token;
  final String userId;

  BookProvider(
      {required this.token,
      required this.userId,
      required this.bookId,
      required this.bookName,
      required this.total,
      required this.cashIn,
      required this.cashOut});

  List<TransactionProvider> get listTransactions {
    return [..._transactions];
  }

  Future<void> getTransactions() async {
    try {
      final url = Uri.parse(
          "${dotenv.env['API_URL']}/api/v1/transaction/gettransaction?bookId=$bookId");

      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Charset': 'utf-8',
        'api-key': '${dotenv.env['API_KEY']}',
        'Authorization': 'Bearer $token'
      };

      final response = await http.get(url, headers: headers);

      final responseData = jsonDecode(response.body);

      final extractedData = responseData["data"] as List;

      List<TransactionProvider> loadedTransactions = [];

      for (int i = 0; i < extractedData.length; i++) {
        loadedTransactions.add(TransactionProvider(
            type: extractedData[i]['types'].toString() == "cashIn"
                ? TransactionType.cashIn
                : TransactionType.cashOut,
            amount: extractedData[i]['amount'].toDouble(),
            bookId: extractedData[i]['bookId'].toString(),
            details: extractedData[i]['details'].toString()));
      }

      _transactions = loadedTransactions;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTransaction(
      String detail, double amount, TransactionType type, String bookId) async {
    try {
      final url =
          Uri.parse("${dotenv.env['API_URL']}/api/v1/transaction/create");

      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Charset': 'utf-8',
        'api-key': '${dotenv.env['API_KEY']}',
        'Authorization': 'Bearer $token'
      };

      final response = await http.post(url,
          body: json.encode(
            {
              "details": detail,
              "amount": amount,
              "types": type == TransactionType.cashIn ? "cashIn" : "cashOut",
              "bookId": bookId
            },
          ),
          headers: headers);

      final responseData = json.decode(response.body);

      final extractedData = responseData["data"];

      final newTransaction = TransactionProvider(
          amount: extractedData['amount'].toDouble(),
          bookId: bookId,
          type: type,
          details: extractedData['details']);
      _transactions.insert(0, newTransaction);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
