import 'package:flutter/foundation.dart';

import '../models/book_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class AdminService extends ChangeNotifier {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal() {
    _initSampleData();
  }

  final List<BookModel> _books = [];
  final List<OrderModel> _orders = [];
  final List<UserModel> _users = [];

  List<BookModel> get books => List.unmodifiable(_books);
  List<OrderModel> get orders => List.unmodifiable(_orders);
  List<UserModel> get users => List.unmodifiable(_users);

  // Metrics
  double get totalRevenue => _orders.fold(0.0, (sum, o) => sum + o.totalAmount);
  int get totalBooksCount => _books.length;
  int get totalOrdersCount => _orders.length;
  int get totalUsersCount => _users.length;
  int get lowStockCount => _books.where((b) => b.stockQuantity <= 15).length;

  void _initSampleData() {
    _books.addAll([
      BookModel(
        id: 1,
        title: 'Clean Code: A Handbook of Agile Craftsmanship',
        author: 'Robert C. Martin',
        genreId: 1,
        genreName: 'Computer Science',
        price: 38.99,
        stockQuantity: 25,
        description: 'Even bad code can function. But if code isn\'t clean, it can bring an organization to its knees.',
        coverImageUrl: 'https://covers.openlibrary.org/b/isbn/9780132350884-L.jpg',
        isBestseller: true,
        ratingAvg: 4.8,
        ratingCount: 128,
        publishedYear: 2008,
      ),
      BookModel(
        id: 2,
        title: 'Designing Data-Intensive Applications',
        author: 'Martin Kleppmann',
        genreId: 1,
        genreName: 'Computer Science',
        price: 44.50,
        stockQuantity: 18,
        description: 'The definitive guide to distributed systems, storage engines, and high-scale architecture.',
        coverImageUrl: 'https://covers.openlibrary.org/b/isbn/9781449373320-L.jpg',
        isBestseller: true,
        isNewArrival: true,
        ratingAvg: 4.9,
        ratingCount: 94,
        publishedYear: 2017,
      ),
      BookModel(
        id: 3,
        title: 'The Pragmatic Programmer',
        author: 'David Thomas & Andrew Hunt',
        genreId: 1,
        genreName: 'Computer Science',
        price: 41.00,
        stockQuantity: 12,
        description: 'Your journey to mastery: continuous learning, craftsmanship, and pragmatic engineering.',
        coverImageUrl: 'https://covers.openlibrary.org/b/isbn/9780135957059-L.jpg',
        isBestseller: true,
        ratingAvg: 4.7,
        ratingCount: 85,
        publishedYear: 2019,
      ),
      BookModel(
        id: 4,
        title: 'Atomic Habits',
        author: 'James Clear',
        genreId: 5,
        genreName: 'Philosophy & Psychology',
        price: 21.99,
        stockQuantity: 40,
        description:
            'An easy & proven way to build good habits and break bad ones.',
        coverImageUrl: 'https://covers.openlibrary.org/b/isbn/9780735211292-L.jpg',
        isBestseller: true,
        ratingAvg: 4.9,
        ratingCount: 310,
        publishedYear: 2018,
      ),
      BookModel(
        id: 5,
        title: 'Zero to One: Notes on Startups',
        author: 'Peter Thiel',
        genreId: 3,
        genreName: 'Business & Finance',
        price: 24.50,
        stockQuantity: 30,
        description: 'How to build companies that create new things, move from 0 to 1, and shape the future.',
        coverImageUrl: 'https://covers.openlibrary.org/b/isbn/9780804139298-L.jpg',
        isNewArrival: true,
        ratingAvg: 4.6,
        ratingCount: 62,
        publishedYear: 2014,
      ),
      BookModel(
        id: 6,
        title: '1984',
        author: 'George Orwell',
        genreId: 2,
        genreName: 'Fiction & Literature',
        price: 14.99,
        stockQuantity: 50,
        description: 'The iconic dystopian masterpiece exploring surveillance, truth, and state totalitarianism.',
        coverImageUrl: 'https://covers.openlibrary.org/b/isbn/9780451524935-L.jpg',
        isBestseller: true,
        ratingAvg: 4.8,
        ratingCount: 240,
        publishedYear: 1949,
      ),
      BookModel(
        id: 7,
        title: 'Flutter in Action',
        author: 'Eric Windmill',
        genreId: 1,
        genreName: 'Computer Science',
        price: 39.99,
        stockQuantity: 15,
        description: 'Practical cross-platform mobile application development with Dart and Flutter.',
        coverImageUrl: 'https://covers.openlibrary.org/b/isbn/9781617294440-L.jpg',
        isNewArrival: true,
        ratingAvg: 4.5,
        ratingCount: 38,
        publishedYear: 2020,
      ),
    ]);

    _orders.addAll([
      OrderModel(
        id: 1,
        orderNumber: 'ORD-2026-001',
        customerName: 'Isaac Student',
        customerEmail: 'student@aptech.com',
        totalAmount: 83.49,
        shippingFee: 5.00,
        status: 'PROCESSING',
        shippingAddress: '14 Aptech Boulevard, Tech Park, Suite 402',
        contactPhone: '+234 801 234 5678',
        trackingNumber: 'TRK-982341-AP',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      OrderModel(
        id: 2,
        orderNumber: 'ORD-2026-002',
        customerName: 'Jane Reader',
        customerEmail: 'jane.reader@example.com',
        totalAmount: 41.00,
        shippingFee: 0.00,
        status: 'SHIPPED',
        shippingAddress: '22 Silicon Crescent, Victoria Island',
        contactPhone: '+234 809 876 5432',
        trackingNumber: 'TRK-109284-AP',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);

    _users.addAll([
      UserModel(
        id: 1,
        email: 'admin@aptech.com',
        fullName: 'Aptech Administrator',
        role: 'ADMIN',
      ),
      UserModel(
        id: 2,
        email: 'student@aptech.com',
        fullName: 'Isaac Student',
        role: 'CUSTOMER',
        address: '14 Aptech Boulevard',
        phoneNumber: '+234 801 234 5678',
      ),
      UserModel(
        id: 3,
        email: 'jane.reader@example.com',
        fullName: 'Jane Reader',
        role: 'CUSTOMER',
        address: '22 Silicon Crescent',
      ),
    ]);
  }

  // Book Catalog Operations (Add, Update, Remove)
  void addBook(BookModel book) {
    final newId = _books.isEmpty
        ? 1
        : (_books.map((b) => b.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    _books.insert(0, book.copyWith(id: newId));
    notifyListeners();
  }

  void updateBook(BookModel updatedBook) {
    final idx = _books.indexWhere((b) => b.id == updatedBook.id);
    if (idx != -1) {
      _books[idx] = updatedBook;
      notifyListeners();
    }
  }

  void updateRatings(int bookId, double ratingAvg, int ratingCount) {
    final idx = _books.indexWhere((b) => b.id == bookId);
    if (idx == -1) return;
    _books[idx] = _books[idx].copyWith(
      ratingAvg: double.parse(ratingAvg.toStringAsFixed(1)),
      ratingCount: ratingCount,
    );
    notifyListeners();
  }

  void deleteBook(int id) {
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  OrderModel? orderByNumber(String orderNumber) {
    final matches = _orders.where((o) => o.orderNumber == orderNumber);
    return matches.isEmpty ? null : matches.first;
  }

  OrderModel addDemoOrder(OrderModel order) {
    final newId = _orders.isEmpty
        ? 1
        : (_orders.map((o) => o.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
    final created = OrderModel(
      id: newId,
      orderNumber: order.orderNumber,
      customerName: order.customerName,
      customerEmail: order.customerEmail,
      totalAmount: order.totalAmount,
      shippingFee: order.shippingFee,
      status: order.status,
      shippingAddress: order.shippingAddress,
      contactPhone: order.contactPhone,
      paymentMethod: order.paymentMethod,
      paymentStatus: order.paymentStatus,
      trackingNumber: order.trackingNumber,
      createdAt: order.createdAt,
    );
    _orders.insert(0, created);
    notifyListeners();
    return created;
  }

  // Order Operations (Update Status)
  void updateOrderStatus(String orderNumber, String newStatus) {
    final idx = _orders.indexWhere((o) => o.orderNumber == orderNumber);
    if (idx != -1) {
      _orders[idx].status = newStatus;
      notifyListeners();
    }
  }

  // User Operations
  void addUser(UserModel user) {
    final exists = _users.any((u) => u.email.toLowerCase() == user.email.toLowerCase());
    if (!exists) {
      _users.add(user);
      notifyListeners();
    }
  }
}
