import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final IconData? prefixIcon;
  final Widget? suffix;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final bool autofocus;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffix,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: widget.isPassword ? _obscure : false,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: AppColors.primaryRed,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: AppColors.textSecondary,
                  )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : widget.suffix,
          ),
        ),
      ],
    );
  }
}
