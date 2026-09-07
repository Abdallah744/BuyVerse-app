import '../../domain/entities/user_entites.dart';

class UserModels extends UserEntites {
  UserModels({
    required super.name,
    required super.email,
    required super.phone,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.pic,
    super.token,
  });

  final String? createdAt;
  final String? updatedAt;
  final int? id;
  final String? pic;

  factory UserModels.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    return UserModels(
      name: (user['name'] ?? json['name'] ?? 'User').toString(),
      email: (user['email'] ?? json['email'] ?? '').toString(),
      phone: (user['phone'] ?? json['phone'] ?? '').toString(),
      createdAt: (user['created_at'] ?? json['created_at'] ?? '').toString(),
      updatedAt: (user['updated_at'] ?? json['updated_at'] ?? '').toString(),
      id: int.tryParse((user['id'] ?? json['id'] ?? '0').toString()),
      pic: (user['pic'] ?? json['pic'] ?? '').toString(),
      token: (json['token'] ?? json['access_token'] ?? '').toString().isEmpty
          ? null
          : (json['token'] ?? json['access_token'] ?? '').toString(),
    );
  }

  Map<String, Object> tomap() {
    return {
      'name': name ?? '',
      'email': email ?? '',
      'phone': phone ?? '',
      'created_at': createdAt ?? '',
      'updated_at': updatedAt ?? '',
      'id': id ?? 0,
      'pic': pic ?? '',
    };
  }
}
