import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class BrandHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const BrandHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Monogram
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDefault, width: 1),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  Positioned(
                    top: 8,
                    right: 10,
                    child: Container(
                      width: 4,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'APTECH',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRedMuted,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.primaryRedDark,
                          width: 0.8,
                        ),
                      ),
                      child: const Text(
                        'BOOKS',
                        style: TextStyle(
                          color: AppColors.primaryRedLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'eProject Bookstore',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
