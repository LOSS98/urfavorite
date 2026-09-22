class ProductCategory {
  final String slug;
  final String name;
  final String coverImage;

  const ProductCategory({
    required this.slug,
    required this.name,
    this.coverImage = '',
  });

  ProductCategory copyWith({String? coverImage}) {
    return ProductCategory(
      slug: slug,
      name: name,
      coverImage: coverImage ?? this.coverImage,
    );
  }

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}
