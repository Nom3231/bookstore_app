import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String title;
  final String message;

  const DeleteConfirmDialog({
    super.key,
    required this.title,
    required this.message,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmDialog(title: title, message: message),
    );
    return res ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderDefault, width: 1),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0x1AEF4444),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.delete_forever_rounded,
              color: AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete Book'),
        ),
      ],
    );
  }
}
