import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/book_cover_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/models/order_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/admin_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/cart_service.dart';
import '../orders/order_tracking_screen.dart';

class CartScreen extends StatelessWidget {
  final UserModel currentUser;
  final VoidCallback? onKeepShopping;

  const CartScreen({
    super.key,
    required this.currentUser,
    this.onKeepShopping,
  });

  @override
  Widget build(BuildContext context) {
    final cart = CartService();

    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        if (cart.items.isEmpty) {
          return _EmptyCart(onKeepShopping: onKeepShopping);
        }

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Your cart',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          BookCoverImage(
                            imageUrl: item.book.coverImageUrl,
                            width: 64,
                            height: 92,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.book.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  item.book.author,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${item.lineTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () => cart.setQuantity(
                                  item.book.id!,
                                  item.quantity + 1,
                                ),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              IconButton(
                                onPressed: () => cart.setQuantity(
                                  item.book.id!,
                                  item.quantity - 1,
                                ),
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.borderSubtle)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const Spacer(),
                        Text(
                          '\$${cart.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Payment is demo only — no charge will be made.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      text: 'Place order (demo)',
                      icon: Icons.lock_outline_rounded,
                      onPressed: () {
                        final user = AuthService().currentUser ?? currentUser;
                        final placed = AdminService().addDemoOrder(
                          OrderModel(
                            orderNumber:
                                'ORD-${DateTime.now().millisecondsSinceEpoch % 100000}',
                            customerName: user.fullName,
                            customerEmail: user.email,
                            totalAmount: cart.subtotal,
                            status: 'PENDING',
                            shippingAddress:
                                (user.address != null && user.address!.trim().isNotEmpty)
                                    ? user.address!
                                    : 'Address on file',
                            contactPhone:
                                (user.phoneNumber != null && user.phoneNumber!.trim().isNotEmpty)
                                    ? user.phoneNumber!
                                    : 'Not provided',
                            paymentMethod: 'DEMO CARD',
                            paymentStatus: 'PAID (DEMO)',
                            trackingNumber:
                                'TRK-${DateTime.now().millisecondsSinceEpoch % 1000000}',
                            createdAt: DateTime.now(),
                          ),
                        );
                        cart.clear();
                        Navigator.push(
                          context,
                          OrderTrackingScreen.route(placed.orderNumber),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final VoidCallback? onKeepShopping;

  const _EmptyCart({this.onKeepShopping});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 56,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a title from Discover or Explore.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onKeepShopping,
              child: const Text('Keep shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
