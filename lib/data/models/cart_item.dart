import 'book_model.dart';

class CartItem {
  final BookModel book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});

  double get lineTotal => book.price * quantity;
}
