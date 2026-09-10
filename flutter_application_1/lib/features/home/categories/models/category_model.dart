class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.slug,
    this.parentId,
    this.description,
  });

  final int id;
  final String name;
  final String? image;
  final String? slug;
  final int? parentId;
  final String? description;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['category_id'] ?? json['categoryId'] ?? 0;
    final rawName =
        json['name'] ?? json['title'] ?? json['category_name'] ?? 'Category';

    return CategoryModel(
      id: int.tryParse(rawId.toString()) ?? 0,
      name: rawName.toString(),
      image: (json['image'] ??
              json['image_url'] ??
              json['icon'] ??
              json['thumbnail'])
          ?.toString(),
      slug: (json['slug'] ?? json['code'])?.toString(),
      parentId: int.tryParse(
        (json['parent_id'] ?? json['parentId'] ?? json['parent'])?.toString() ??
            '',
      ),
      description: (json['description'] ?? json['details'])?.toString(),
    );
  }

  static List<CategoryModel> fromList(dynamic rawData) {
    if (rawData is List) {
      return rawData
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();
    }

    if (rawData is Map<String, dynamic>) {
      final keys = ['data', 'categories', 'result', 'items'];
      for (final key in keys) {
        final value = rawData[key];
        if (value is List) {
          return value
              .whereType<Map<String, dynamic>>()
              .map(CategoryModel.fromJson)
              .toList();
        }
      }
    }

    return const [];
  }
}
