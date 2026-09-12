import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/book_cover_image.dart';
import '../../data/models/book_model.dart';
import '../../data/services/admin_service.dart';
import '../../data/services/cart_service.dart';
import '../book_detail/book_detail_sheet.dart';

class ExploreScreen extends StatefulWidget {
  final VoidCallback? onOpenCart;

  const ExploreScreen({super.key, this.onOpenCart});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final AdminService _adminService = AdminService();
  String _query = '';
  String _genre = 'All';
  String _sort = 'popularity';

  final _genres = const [
    'All',
    'Computer Science',
    'Fiction & Literature',
    'Business & Finance',
    'Philosophy & Psychology',
  ];

  @override
  void initState() {
    super.initState();
    _adminService.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _adminService.removeListener(_refresh);
    super.dispose();
  }

  List<BookModel> get _books {
    var books = _adminService.books.where((book) {
      final matchesGenre = _genre == 'All' || book.genreName == _genre;
      final matchesQuery = _query.isEmpty ||
          book.title.toLowerCase().contains(_query) ||
          book.author.toLowerCase().contains(_query) ||
          book.genreName.toLowerCase().contains(_query);
      return matchesGenre && matchesQuery;
    }).toList();

    books.sort((a, b) {
      switch (_sort) {
        case 'price_low':
          return a.price.compareTo(b.price);
        case 'price_high':
          return b.price.compareTo(a.price);
        case 'newest':
          return (b.publishedYear ?? 0).compareTo(a.publishedYear ?? 0);
        default:
          return b.ratingCount.compareTo(a.ratingCount);
      }
    });
    return books;
  }

  @override
  Widget build(BuildContext context) {
    final books = _books;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Explore',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (value) =>
                  setState(() => _query = value.trim().toLowerCase()),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search title, author, genre',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderSubtle),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderSubtle),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _genres.map((genre) {
                final selected = genre == _genre;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(genre),
                    selected: selected,
                    onSelected: (_) => setState(() => _genre = genre),
                    selectedColor: AppColors.primaryRed,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.borderSubtle),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
            child: Row(
              children: [
                Text(
                  '${books.length} titles',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sort,
                    onChanged: (value) {
                      if (value != null) setState(() => _sort = value);
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'popularity',
                        child: Text('Popularity'),
                      ),
                      DropdownMenuItem(
                        value: 'price_low',
                        child: Text('Price: low to high'),
                      ),
                      DropdownMenuItem(
                        value: 'price_high',
                        child: Text('Price: high to low'),
                      ),
                      DropdownMenuItem(
                        value: 'newest',
                        child: Text('Newest'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return _ExploreCard(
                  book: book,
                  onOpen: () => BookDetailSheet.show(
                    context,
                    book,
                    onViewCart: widget.onOpenCart,
                  ),
                  onAdd: () {
                    CartService().add(book);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added "${book.title}" to cart')),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onOpen;
  final VoidCallback onAdd;

  const _ExploreCard({
    required this.book,
    required this.onOpen,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BookCoverImage(
                imageUrl: book.coverImageUrl,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '\$${book.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onAdd,
                  child: const Icon(
                    Icons.add_shopping_cart_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
