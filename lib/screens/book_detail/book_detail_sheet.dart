import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/book_cover_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/models/book_model.dart';
import '../../data/services/cart_service.dart';
import '../../data/services/wishlist_service.dart';

class BookDetailSheet extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onViewCart;

  const BookDetailSheet({super.key, required this.book, this.onViewCart});

  static void show(
    BuildContext context,
    BookModel book, {
    VoidCallback? onViewCart,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => BookDetailSheet(book: book, onViewCart: onViewCart),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: BookCoverImage(
                  imageUrl: book.coverImageUrl,
                  width: 105,
                  height: 155,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRedMuted,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primaryRedDark,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            book.genreName,
                            style: const TextStyle(
                              color: AppColors.primaryRedLight,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (book.isBestseller) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x2AF59E0B),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.local_fire_department_rounded,
                                  size: 12,
                                  color: Color(0xFFF59E0B),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  'Hot',
                                  style: TextStyle(
                                    color: Color(0xFFF59E0B),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      book.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'by ${book.author}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB800),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          book.ratingAvg.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${book.ratingCount} reviews)',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SpecColumn(
                  label: 'Price',
                  value: '\$${book.price.toStringAsFixed(2)}',
                  highlight: true,
                ),
                Container(height: 24, width: 1, color: AppColors.borderSubtle),
                _SpecColumn(
                  label: 'Inventory',
                  value: '${book.stockQuantity} In Stock',
                ),
                Container(height: 24, width: 1, color: AppColors.borderSubtle),
                _SpecColumn(label: 'Format', value: 'Paperback'),
                Container(height: 24, width: 1, color: AppColors.borderSubtle),
                _SpecColumn(
                  label: 'Year',
                  value: '${book.publishedYear ?? 2024}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Synopsis & Overview',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                book.description.isNotEmpty
                    ? book.description
                    : 'A compelling literary masterwork showcasing exceptional writing, thought-provoking insights, and lasting thematic resonance.',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                  height: 1.55,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              AnimatedBuilder(
                animation: WishlistService(),
                builder: (context, _) {
                  final saved = WishlistService().contains(book.id);
                  return Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.borderDefault,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        saved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: AppColors.textPrimary,
                        size: 22,
                      ),
                      onPressed: () {
                        WishlistService().toggle(book);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              saved
                                  ? 'Removed from wishlist'
                                  : 'Added to your wishlist',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Add to Cart • \$${book.price.toStringAsFixed(2)}',
                  icon: Icons.shopping_bag_outlined,
                  onPressed: () {
                    CartService().add(book);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added "${book.title}" to Cart'),
                        backgroundColor: AppColors.surfaceElevated,
                        action: SnackBarAction(
                          label: 'VIEW CART',
                          textColor: AppColors.primaryRedLight,
                          onPressed: () => onViewCart?.call(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpecColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SpecColumn({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlight
                ? AppColors.primaryRedLight
                : AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
