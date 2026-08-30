/// Product entity used across catalog, cart and favorites.
class ProductModel {
  final int id;
  final String title;
  final int price;
  final String description;
  final String category;
  final List<String> images;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  String get imageUrl {
    if (images.isEmpty) {
      return 'https://placehold.co/600x600?text=No+Image';
    }
    return images.first;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      category: category is Map<String, dynamic>
          ? category['name'] as String? ?? 'Uncategorized'
          : category is String
              ? category
              : 'Uncategorized',
      images: json['images'] is List
          ? List<String>.from(json['images'] as List)
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'images': images,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is ProductModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}