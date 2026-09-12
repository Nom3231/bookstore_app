import 'package:flutter/foundation.dart';

import '../models/book_model.dart';
import '../models/cart_item.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.lineTotal);

  void add(BookModel book) {
    final index = _items.indexWhere((item) => item.book.id == book.id);
    if (index == -1) {
      _items.add(CartItem(book: book));
    } else {
      _items[index].quantity += 1;
    }
    notifyListeners();
  }

  void setQuantity(int bookId, int quantity) {
    final index = _items.indexWhere((item) => item.book.id == bookId);
    if (index == -1) return;
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = quantity;
    }
    notifyListeners();
  }

  void remove(int bookId) {
    _items.removeWhere((item) => item.book.id == bookId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
