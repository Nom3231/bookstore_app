import 'package:flutter/foundation.dart';

import '../models/book_model.dart';

class WishlistService extends ChangeNotifier {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  final List<BookModel> _books = [];

  List<BookModel> get books => List.unmodifiable(_books);

  bool contains(int? bookId) =>
      bookId != null && _books.any((book) => book.id == bookId);

  void toggle(BookModel book) {
    final index = _books.indexWhere((item) => item.id == book.id);
    if (index == -1) {
      _books.add(book);
    } else {
      _books.removeAt(index);
    }
    notifyListeners();
  }
}
