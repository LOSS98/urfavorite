String formatPrice(double value) => '${value.toStringAsFixed(2)} €';

String formatRating(double value) => value.toStringAsFixed(1);

String categoryLabel(String slug) {
  return slug
      .split('-')
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
