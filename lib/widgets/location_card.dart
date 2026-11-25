import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../themes/app_theme.dart';

class LocationCard extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onTap;
  final VoidCallback? onFavoritePressed;
  final bool isFavorite;
  const LocationCard({
    super.key,
    required this.location,
    required this.onTap,
    required this.isFavorite,
    this.onFavoritePressed,
  });
  @override
  Widget build(BuildContext context) => Material(
    color: AppTheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: AppTheme.textPrimary),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.fullAddress,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: isFavorite
                  ? 'Hapus dari favorit'
                  : 'Tambahkan ke favorit',
              onPressed: onFavoritePressed,
              style: IconButton.styleFrom(
                backgroundColor: isFavorite
                    ? AppTheme.primaryLight
                    : AppTheme.background,
                foregroundColor: isFavorite
                    ? AppTheme.primary
                    : AppTheme.textPrimary,
              ),
              icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
