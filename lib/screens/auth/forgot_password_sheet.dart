import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/services/auth_service.dart';

class ForgotPasswordSheet extends StatefulWidget {
  final String? initialEmail;

  const ForgotPasswordSheet({super.key, this.initialEmail});

  static Future<void> show(BuildContext context, {String? initialEmail}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => ForgotPasswordSheet(initialEmail: initialEmail),
    );
  }

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _isLoading = false;
  String? _statusMessage;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    final res = await AuthService().forgotPassword(
      _emailController.text.trim(),
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isSuccess = res.success;
      _statusMessage = res.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, bottomInset + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center grab handle
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRedMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.primaryRedLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter your registered email address and we will send you a link to reset your account credentials.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            if (_statusMessage != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isSuccess
                      ? const Color(0x1A10B981)
                      : const Color(0x1AEF4444),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isSuccess ? AppColors.success : AppColors.error,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isSuccess
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      color: _isSuccess ? AppColors.success : AppColors.error,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: TextStyle(
                          color: _isSuccess
                              ? AppColors.success
                              : AppColors.error,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (!_isSuccess) ...[
              CustomTextField(
                label: 'Email Address',
                hintText: 'name@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.alternate_email_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!val.contains('@') || !val.contains('.')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Send Reset Link',
                isLoading: _isLoading,
                onPressed: _handleReset,
              ),
            ] else ...[
              PrimaryButton(
                text: 'Done',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
