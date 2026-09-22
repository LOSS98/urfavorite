import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../theme/app_theme.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap,
    this.selected = false,
  });

  final ProductCategory category;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 104,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              height: 76,
              width: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primaryStart : AppColors.border,
                  width: selected ? 2.5 : 1.5,
                ),
              ),
              padding: const EdgeInsets.all(4),
              child: ClipOval(
                child: category.coverImage.isEmpty
                    ? Container(
                        color: AppColors.background,
                        child: const Icon(Icons.category_rounded, color: AppColors.textSecondary),
                      )
                    : CachedNetworkImage(
                        imageUrl: category.coverImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: AppColors.background),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.background,
                          child: const Icon(Icons.category_rounded, color: AppColors.textSecondary),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? AppColors.primaryStart : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
