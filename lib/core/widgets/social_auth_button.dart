import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum SocialProvider { google, apple }

class SocialAuthButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isGoogle = provider == SocialProvider.google;

    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSubtle, width: 1),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isGoogle ? Icons.g_mobiledata_rounded : Icons.apple,
                color: Colors.white,
                size: isGoogle ? 28 : 22,
              ),
              const SizedBox(width: 8),
              Text(
                isGoogle ? 'Google' : 'Apple',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
