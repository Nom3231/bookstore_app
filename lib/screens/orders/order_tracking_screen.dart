import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';
import '../../data/services/admin_service.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderNumber;

  const OrderTrackingScreen({super.key, required this.orderNumber});

  static const _steps = [
    (
      key: 'PENDING',
      title: 'Placed',
      subtitle: 'Order received and payment marked demo-paid.',
      icon: Icons.receipt_long_rounded,
    ),
    (
      key: 'PROCESSING',
      title: 'Packed',
      subtitle: 'Warehouse is packing your books.',
      icon: Icons.inventory_2_outlined,
    ),
    (
      key: 'SHIPPED',
      title: 'Shipped',
      subtitle: 'Courier has the parcel. Track with the number below.',
      icon: Icons.local_shipping_outlined,
    ),
    (
      key: 'DELIVERED',
      title: 'Delivered',
      subtitle: 'Left at your shipping address.',
      icon: Icons.home_outlined,
    ),
  ];

  static Route<void> route(String orderNumber) {
    return MaterialPageRoute(
      builder: (_) => OrderTrackingScreen(orderNumber: orderNumber),
    );
  }

  DateTime _stamp(OrderModel order, int step) {
    switch (step) {
      case 0:
        return order.createdAt;
      case 1:
        return order.createdAt.add(const Duration(hours: 4));
      case 2:
        return order.createdAt.add(const Duration(days: 1));
      default:
        return order.createdAt.add(const Duration(days: 4));
    }
  }

  String _format(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, $hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Track order'),
        backgroundColor: AppColors.background,
      ),
      body: AnimatedBuilder(
        animation: AdminService(),
        builder: (context, _) {
          final order = AdminService().orderByNumber(orderNumber);
          if (order == null) {
            return const Center(
              child: Text(
                'Order not found.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            );
          }

          final step = order.timelineStep;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            order.orderNumber,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        _StatusPill(order: order),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tracking  ${order.trackingNumber ?? 'Assigned at dispatch'}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total \$${order.totalAmount.toStringAsFixed(2)}  •  ${order.paymentStatus}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (order.isCancelled) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'This order was cancelled. No further delivery updates.',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 22),
              const Text(
                'Delivery status',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(_steps.length, (index) {
                final item = _steps[index];
                final done = step >= index;
                final current = step == index;
                return _TimelineTile(
                  title: item.title,
                  subtitle: item.subtitle,
                  icon: item.icon,
                  done: done,
                  current: current,
                  isLast: index == _steps.length - 1,
                  stampLabel: done
                      ? (current && step < 3 ? 'In progress' : _format(_stamp(order, index)))
                      : 'Expected ${_format(_stamp(order, index))}',
                );
              }),
              const SizedBox(height: 18),
              const Text(
                'Shipping to',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
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
                      order.customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.shippingAddress,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.contactPhone,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Courier updates are demo-only. An admin can change the status in the dashboard.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final OrderModel order;

  const _StatusPill({required this.order});

  @override
  Widget build(BuildContext context) {
    final cancelled = order.isCancelled;
    final delivered = order.status.toUpperCase() == 'DELIVERED';
    final color = cancelled
        ? AppColors.error
        : delivered
        ? AppColors.success
        : AppColors.primaryRed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        order.statusLabel.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool done;
  final bool current;
  final bool isLast;
  final String stampLabel;

  const _TimelineTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.done,
    required this.current,
    required this.isLast,
    required this.stampLabel,
  });

  @override
  Widget build(BuildContext context) {
    final accent = current
        ? AppColors.primaryRed
        : done
        ? AppColors.success
        : AppColors.borderStrong;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: done || current
                    ? accent.withValues(alpha: 0.15)
                    : AppColors.surfaceElevated,
                shape: BoxShape.circle,
                border: Border.all(color: accent, width: current ? 2 : 1),
              ),
              child: Icon(
                done && !current ? Icons.check_rounded : icon,
                size: 18,
                color: accent,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 52,
                color: done ? AppColors.success.withValues(alpha: 0.4) : AppColors.borderSubtle,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: done || current
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stampLabel,
                  style: TextStyle(
                    color: current ? AppColors.primaryRed : AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
