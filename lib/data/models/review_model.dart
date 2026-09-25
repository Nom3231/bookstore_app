class ReviewModel {
  final int id;
  final int bookId;
  final String userName;
  final String userEmail;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final Set<String> likedBy;

  ReviewModel({
    required this.id,
    required this.bookId,
    required this.userName,
    required this.userEmail,
    required this.rating,
    required this.comment,
    required this.createdAt,
    Set<String>? likedBy,
  }) : likedBy = likedBy ?? {};

  int get likeCount => likedBy.length;

  bool isLikedBy(String? email) {
    if (email == null || email.isEmpty) return false;
    return likedBy.contains(email.trim().toLowerCase());
  }
}
