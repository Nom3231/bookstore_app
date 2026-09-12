class BookModel {
  final int? id;
  final String title;
  final String author;
  final int genreId;
  final String genreName;
  final double price;
  final double? discountPrice;
  final int stockQuantity;
  final String description;
  final String coverImageUrl;
  final bool isBestseller;
  final bool isNewArrival;
  final double ratingAvg;
  final int ratingCount;
  final int? publishedYear;

  BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.genreId,
    this.genreName = 'General',
    required this.price,
    this.discountPrice,
    this.stockQuantity = 10,
    required this.description,
    required this.coverImageUrl,
    this.isBestseller = false,
    this.isNewArrival = false,
    this.ratingAvg = 4.5,
    this.ratingCount = 10,
    this.publishedYear,
  });

  BookModel copyWith({
    int? id,
    String? title,
    String? author,
    int? genreId,
    String? genreName,
    double? price,
    double? discountPrice,
    int? stockQuantity,
    String? description,
    String? coverImageUrl,
    bool? isBestseller,
    bool? isNewArrival,
    double? ratingAvg,
    int? ratingCount,
    int? publishedYear,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      genreId: genreId ?? this.genreId,
      genreName: genreName ?? this.genreName,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      isBestseller: isBestseller ?? this.isBestseller,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      publishedYear: publishedYear ?? this.publishedYear,
    );
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int?,
      title: json['title'] as String? ?? 'Untitled',
      author: json['author'] as String? ?? 'Unknown',
      genreId: json['genreId'] as int? ?? (json['genre_id'] as int? ?? 1),
      genreName: json['genreName'] as String? ?? 'General',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      stockQuantity:
          json['stockQuantity'] as int? ??
          (json['stock_quantity'] as int? ?? 0),
      description: json['description'] as String? ?? '',
      coverImageUrl:
          json['coverImageUrl'] as String? ??
          (json['cover_image_url'] as String? ?? ''),
      isBestseller:
          json['isBestseller'] as bool? ??
          (json['is_bestseller'] as bool? ?? false),
      isNewArrival:
          json['isNewArrival'] as bool? ??
          (json['is_new_arrival'] as bool? ?? false),
      ratingAvg:
          (json['ratingAvg'] as num?)?.toDouble() ??
          (json['rating_avg'] as num?)?.toDouble() ??
          4.5,
      ratingCount:
          json['ratingCount'] as int? ?? (json['rating_count'] as int? ?? 0),
      publishedYear:
          json['publishedYear'] as int? ?? json['published_year'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genreId': genreId,
      'genreName': genreName,
      'price': price,
      'discountPrice': discountPrice,
      'stockQuantity': stockQuantity,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'isBestseller': isBestseller,
      'isNewArrival': isNewArrival,
      'ratingAvg': ratingAvg,
      'ratingCount': ratingCount,
      'publishedYear': publishedYear,
    };
  }
}
