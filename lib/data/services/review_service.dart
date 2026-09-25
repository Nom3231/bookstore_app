import 'package:flutter/foundation.dart';

import '../models/review_model.dart';
import 'admin_service.dart';

class ReviewService extends ChangeNotifier {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal() {
    _seed();
  }

  final List<ReviewModel> _reviews = [];
  int _nextId = 1;

  List<ReviewModel> forBook(int? bookId) {
    if (bookId == null) return const [];
    final items = _reviews.where((r) => r.bookId == bookId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  bool hasReviewed(int? bookId, String? email) {
    if (bookId == null || email == null) return false;
    final clean = email.trim().toLowerCase();
    return _reviews.any(
      (r) => r.bookId == bookId && r.userEmail.toLowerCase() == clean,
    );
  }

  double averageFor(int? bookId) {
    final items = forBook(bookId);
    if (items.isEmpty) return 0;
    final total = items.fold<int>(0, (sum, r) => sum + r.rating);
    return total / items.length;
  }

  String addReview({
    required int bookId,
    required String userName,
    required String userEmail,
    required int rating,
    required String comment,
  }) {
    final cleanEmail = userEmail.trim().toLowerCase();
    if (hasReviewed(bookId, cleanEmail)) {
      return 'You have already reviewed this book.';
    }
    if (rating < 1 || rating > 5) {
      return 'Please choose a rating from 1 to 5 stars.';
    }
    final text = comment.trim();
    if (text.length < 8) {
      return 'Write a short review (at least 8 characters).';
    }

    _reviews.add(
      ReviewModel(
        id: _nextId++,
        bookId: bookId,
        userName: userName,
        userEmail: cleanEmail,
        rating: rating,
        comment: text,
        createdAt: DateTime.now(),
      ),
    );
    _syncBookRatings(bookId);
    notifyListeners();
    return '';
  }

  void toggleLike(int reviewId, String userEmail) {
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index == -1) return;
    final email = userEmail.trim().toLowerCase();
    if (email.isEmpty) return;
    final liked = Set<String>.from(_reviews[index].likedBy);
    if (liked.contains(email)) {
      liked.remove(email);
    } else {
      liked.add(email);
    }
    final current = _reviews[index];
    _reviews[index] = ReviewModel(
      id: current.id,
      bookId: current.bookId,
      userName: current.userName,
      userEmail: current.userEmail,
      rating: current.rating,
      comment: current.comment,
      createdAt: current.createdAt,
      likedBy: liked,
    );
    notifyListeners();
  }

  void _syncBookRatings(int bookId) {
    final items = forBook(bookId);
    if (items.isEmpty) return;
    AdminService().updateRatings(bookId, averageFor(bookId), items.length);
  }

  void _seed() {
    void add({
      required int bookId,
      required String name,
      required String email,
      required int rating,
      required String comment,
      required int daysAgo,
      List<String> likes = const [],
    }) {
      _reviews.add(
        ReviewModel(
          id: _nextId++,
          bookId: bookId,
          userName: name,
          userEmail: email,
          rating: rating,
          comment: comment,
          createdAt: DateTime.now().subtract(Duration(days: daysAgo)),
          likedBy: likes.map((e) => e.toLowerCase()).toSet(),
        ),
      );
    }

    add(
      bookId: 1,
      name: 'Jane Reader',
      email: 'jane.reader@example.com',
      rating: 5,
      comment:
          'This changed how I write code at work. Clear examples and no fluff.',
      daysAgo: 18,
      likes: ['student@aptech.com', 'ada@example.com'],
    );
    add(
      bookId: 1,
      name: 'Chidi Okonkwo',
      email: 'chidi@example.com',
      rating: 4,
      comment:
          'A bit strict in places, but the naming and function-size advice is gold.',
      daysAgo: 9,
      likes: ['jane.reader@example.com'],
    );
    add(
      bookId: 2,
      name: 'Ada Nwosu',
      email: 'ada@example.com',
      rating: 5,
      comment:
          'Best systems book I have read. Dense, but worth a slow second pass.',
      daysAgo: 22,
      likes: ['chidi@example.com', 'student@aptech.com', 'jane.reader@example.com'],
    );
    add(
      bookId: 2,
      name: 'Isaac Student',
      email: 'student@aptech.com',
      rating: 5,
      comment: 'Used this for my distributed systems notes. The diagrams help.',
      daysAgo: 6,
      likes: ['ada@example.com'],
    );
    add(
      bookId: 3,
      name: 'Maya Cole',
      email: 'maya@example.com',
      rating: 4,
      comment:
          'Practical habits you can use the same week. The 20th edition still holds up.',
      daysAgo: 14,
      likes: ['chidi@example.com'],
    );
    add(
      bookId: 4,
      name: 'Tunde Bello',
      email: 'tunde@example.com',
      rating: 5,
      comment:
          'Simple ideas, easy to apply. I actually stuck with a 2-minute habit.',
      daysAgo: 4,
      likes: ['jane.reader@example.com', 'maya@example.com', 'ada@example.com'],
    );
    add(
      bookId: 4,
      name: 'Jane Reader',
      email: 'jane.reader@example.com',
      rating: 5,
      comment: 'Short chapters, no filler. I keep going back to the identity bit.',
      daysAgo: 11,
    );
    add(
      bookId: 5,
      name: 'Chidi Okonkwo',
      email: 'chidi@example.com',
      rating: 4,
      comment:
          'Strong on monopoly thinking. Some chapters feel more manifesto than playbook.',
      daysAgo: 20,
      likes: ['tunde@example.com'],
    );
    add(
      bookId: 6,
      name: 'Ada Nwosu',
      email: 'ada@example.com',
      rating: 5,
      comment:
          'Still unsettling. The slogans and surveillance scenes stay with you.',
      daysAgo: 30,
      likes: ['maya@example.com', 'student@aptech.com'],
    );
    add(
      bookId: 6,
      name: 'Maya Cole',
      email: 'maya@example.com',
      rating: 4,
      comment: 'Required reading. Pacing is slow at first, then it locks in.',
      daysAgo: 8,
    );
    add(
      bookId: 7,
      name: 'Isaac Student',
      email: 'student@aptech.com',
      rating: 4,
      comment:
          'Good Flutter walkthrough. Some widgets are dated, but the layout ideas help.',
      daysAgo: 3,
      likes: ['chidi@example.com'],
    );
    add(
      bookId: 7,
      name: 'Tunde Bello',
      email: 'tunde@example.com',
      rating: 5,
      comment: 'Helped me ship my first Dart UI. Clear project structure.',
      daysAgo: 16,
      likes: ['student@aptech.com', 'ada@example.com'],
    );

    for (final id in {1, 2, 3, 4, 5, 6, 7}) {
      _syncBookRatings(id);
    }
  }
}
