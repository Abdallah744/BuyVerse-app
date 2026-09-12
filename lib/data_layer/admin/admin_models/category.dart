import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String description;
  final String slug;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    this.slug = '',
  });

  @override
  List<Object?> get props => [id, name, description, slug];
}
