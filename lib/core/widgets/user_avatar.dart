import 'dart:convert';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 24,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.onTap,
  });

  Widget _buildImage(String url, Widget fallback) {
    final cleanUrl = url.trim();
    if (cleanUrl.startsWith('data:image/') || cleanUrl.startsWith('data:;base64,')) {
      try {
        final commaIndex = cleanUrl.indexOf(',');
        final base64Str =
            commaIndex != -1 ? cleanUrl.substring(commaIndex + 1) : cleanUrl;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => fallback,
        );
      } catch (_) {
        return fallback;
      }
    }

    return Image.network(
      cleanUrl,
      width: radius * 2,
      height: radius * 2,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String initial =
        name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';

    final Widget fallbackContent = Center(
      child: Text(
        initial,
        style: TextStyle(
          color: foregroundColor ?? AppColors.primaryRedLight,
          fontWeight: FontWeight.w800,
          fontSize: fontSize ?? (radius * 0.75),
        ),
      ),
    );

    Widget avatarWidget;
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      avatarWidget = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? AppColors.surfaceHighlight,
        child: ClipOval(
          child: _buildImage(imageUrl!, fallbackContent),
        ),
      );
    } else {
      avatarWidget = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? AppColors.surfaceHighlight,
        child: fallbackContent,
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }
}
