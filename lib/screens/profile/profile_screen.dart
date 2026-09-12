import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/book_cover_image.dart';
import '../../data/models/user_model.dart';
import '../../data/services/admin_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/cart_service.dart';
import '../../data/services/wishlist_service.dart';
import '../admin/admin_dashboard_screen.dart';
import '../auth/login_screen.dart';
import '../book_detail/book_detail_sheet.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel currentUser;

  const ProfileScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.surfaceHighlight,
                  child: Text(
                    currentUser.fullName.isNotEmpty
                        ? currentUser.fullName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        currentUser.email,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Shipping address',
            value: currentUser.address ?? '14 Aptech Boulevard, Tech Park',
          ),
          _InfoCard(
            title: 'Payment method',
            value: 'Demo card •••• 4242 (dormant)',
          ),
          // Wishlist Section (Live)
          AnimatedBuilder(
            animation: WishlistService(),
            builder: (context, _) {
              final wishlistBooks = WishlistService().books;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Wishlist (${wishlistBooks.length})',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (wishlistBooks.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Text(
                        'Save titles from book pages to see them here.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    )
                  else
                    ...wishlistBooks.map(
                      (book) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => BookDetailSheet.show(context, book),
                              child: BookCoverImage(
                                imageUrl: book.coverImageUrl,
                                width: 44,
                                height: 62,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    BookDetailSheet.show(context, book),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      book.author,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${book.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppColors.primaryRedLight,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Add to Cart',
                              icon: const Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 18,
                                color: AppColors.primaryRedLight,
                              ),
                              onPressed: () {
                                CartService().add(book);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added "${book.title}" to cart',
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              tooltip: 'Remove',
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: AppColors.textMuted,
                              ),
                              onPressed: () {
                                WishlistService().toggle(book);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Orders Section (Live)
          AnimatedBuilder(
            animation: AdminService(),
            builder: (context, _) {
              final userOrders = AdminService().orders
                  .where(
                    (order) =>
                        order.customerEmail.toLowerCase() ==
                        currentUser.email.toLowerCase(),
                  )
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order History (${userOrders.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (userOrders.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Text(
                        'No orders yet. Checkout from cart to place a demo order.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    )
                  else
                    ...userOrders.map(
                      (order) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderSubtle),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.orderNumber,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: order.status == 'DELIVERED'
                                        ? const Color(0x1F10B981)
                                        : AppColors.primaryRedMuted,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    order.status,
                                    style: TextStyle(
                                      color: order.status == 'DELIVERED'
                                          ? const Color(0xFF10B981)
                                          : AppColors.primaryRedLight,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (order.trackingNumber != null)
                                  Text(
                                    order.trackingNumber!,
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          if (currentUser.isAdmin) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AdminDashboardScreen(currentUser: currentUser),
                  ),
                );
              },
              icon: const Icon(Icons.admin_panel_settings_outlined),
              label: const Text('Open admin dashboard'),
            ),
          ],
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () async {
              await AuthService().logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
