class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.price = 0,
    this.slug,
    this.categoryId,
  });

  final int id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final String? slug;
  final int? categoryId;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['product_id'] ?? json['productId'] ?? 0;
    final rawName =
        json['name'] ?? json['title'] ?? json['product_name'] ?? 'Product';
    final rawPrice = json['price'] ??
        json['amount'] ??
        json['regular_price'] ??
        json['sale_price'] ??
        json['current_price'] ??
        0;

    dynamic productImage = json['image'] ?? json['image_url'];
    productImage ??= json['thumbnail'];
    productImage ??= json['featured_image'];
    if (productImage == null && json['images'] is List) {
      final images = json['images'] as List;
      if (images.isNotEmpty) {
        final firstItem = images.first;
        if (firstItem is Map<String, dynamic>) {
          productImage =
              firstItem['image'] ?? firstItem['url'] ?? firstItem['path'];
        } else {
          productImage = firstItem;
        }
      }
    }

    return ProductModel(
      id: int.tryParse(rawId.toString()) ?? 0,
      name: rawName.toString(),
      description:
          (json['description'] ?? json['details'] ?? json['short_description'])
              ?.toString(),
      image: productImage?.toString(),
      price: double.tryParse(rawPrice.toString()) ?? 0,
      slug: (json['slug'] ?? json['code'])?.toString(),
      categoryId: int.tryParse(
        (json['category_id'] ?? json['categoryId'] ?? json['category'])
                ?.toString() ??
            '',
      ),
    );
  }

  static List<ProductModel> fromList(dynamic rawData) {
    if (rawData is List) {
      return rawData
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    }

    if (rawData is Map<String, dynamic>) {
      final keys = ['data', 'products', 'result', 'items'];
      for (final key in keys) {
        final value = rawData[key];
        if (value is List) {
          return value
              .whereType<Map<String, dynamic>>()
              .map(ProductModel.fromJson)
              .toList();
        }
        if (value is Map<String, dynamic>) {
          final nested = value['data'] ?? value['products'] ?? value['items'];
          if (nested is List) {
            return nested
                .whereType<Map<String, dynamic>>()
                .map(ProductModel.fromJson)
                .toList();
          }
        }
      }
    }

    return const [];
  }
}
