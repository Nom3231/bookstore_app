import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Book cover that decodes at device pixel ratio so covers stay sharp
/// on emulator and phone screens.
class BookCoverImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const BookCoverImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  static String sharpenedUrl(String url, int targetWidth) {
    final w = targetWidth.clamp(400, 1600);
    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    if (uri.host.contains('unsplash.com')) {
      final params = Map<String, String>.from(uri.queryParameters);
      params['w'] = '$w';
      params['q'] = '90';
      params['auto'] = 'format';
      params['fit'] = 'crop';
      params['crop'] = 'entropy';
      params['dpr'] = '2';
      return uri.replace(queryParameters: params).toString();
    }

    if (uri.host.contains('openlibrary.org') && uri.path.contains('-L.jpg')) {
      // Open Library L is ~500px; request the same URL (no smaller variant).
      return url;
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context).clamp(1.0, 3.0);

    Widget buildImage(double w, double h) {
      final cacheW = (w * dpr).round().clamp(200, 1600);
      return Image.network(
        sharpenedUrl(imageUrl, cacheW),
        width: w.isFinite ? w : null,
        height: h.isFinite ? h : null,
        fit: fit,
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.medium,
        isAntiAlias: true,
        cacheWidth: cacheW,
        gaplessPlayback: true,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _Placeholder(width: w, height: h, loading: true);
        },
        errorBuilder: (context, error, stackTrace) =>
            _Placeholder(width: w, height: h),
      );
    }

    Widget clipped(Widget child) {
      if (borderRadius == null) return child;
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }

    if (width != null && height != null) {
      return clipped(buildImage(width!, height!));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = width ??
            (constraints.maxWidth.isFinite ? constraints.maxWidth : 160);
        final h = height ??
            (constraints.maxHeight.isFinite ? constraints.maxHeight : 220);
        return clipped(
          SizedBox(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            child: buildImage(w, h),
          ),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double width;
  final double height;
  final bool loading;

  const _Placeholder({
    required this.width,
    required this.height,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.isFinite ? width : null,
      height: height.isFinite ? height : null,
      color: AppColors.surfaceHighlight.withValues(alpha: 0.35),
      alignment: Alignment.center,
      child: Icon(
        loading ? Icons.menu_book_outlined : Icons.menu_book_rounded,
        color: AppColors.textMuted,
        size: 36,
      ),
    );
  }
}
