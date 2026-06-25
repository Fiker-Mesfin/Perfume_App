import 'package:flutter/material.dart';
import 'perfume.dart';

class CartModel extends ChangeNotifier {

  final List<Perfume> _items = [];

  List<Perfume> get items => _items;

  /// ADD ITEM
  void addItem(Perfume perfume) {
    _items.add(perfume);

    notifyListeners();
  }

  /// REMOVE ITEM
  void removeItem(Perfume perfume) {
    _items.remove(perfume);

    notifyListeners();
  }

  /// TOTAL PRICE
  double get totalPrice {
    double total = 0;

    for (var item in _items) {
      total += item.price;
    }

    return total;
  }
}