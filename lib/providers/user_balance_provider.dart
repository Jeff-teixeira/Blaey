import 'package:flutter/foundation.dart';

class UserBalanceProvider with ChangeNotifier {
  double _balance = 0.0;

  double get balance => _balance;

  void setBalance(double newBalance) {
    _balance = newBalance;
    notifyListeners();
  }

  void addToBalance(double amount) {
    _balance += amount;
    notifyListeners();
  }
}