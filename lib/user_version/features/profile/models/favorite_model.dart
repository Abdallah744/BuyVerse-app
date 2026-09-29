class FavoriteModel {
  const FavoriteModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.isFavorite,
    required this.description,
  });

  final int id;
  final String name;
  final String category;
  final String price;
  final String imageUrl;
  final double rating;
  final bool isFavorite;
  final String description;

  static List<FavoriteModel> sampleFavorites() {
    return const [
      FavoriteModel(
        id: 1,
        name: 'Classic Leather Bag',
        category: 'Accessories',
        price: '\$89.00',
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
        rating: 4.8,
        isFavorite: true,
        description: 'Premium finish and roomy interior for everyday style.',
      ),
      FavoriteModel(
        id: 2,
        name: 'Smart Watch Pro',
        category: 'Electronics',
        price: '\$169.00',
        imageUrl:
            'https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&w=800&q=80',
        rating: 4.6,
        isFavorite: true,
        description: 'Track health, notifications, and workouts in one device.',
      ),
      FavoriteModel(
        id: 3,
        name: 'Urban Sneakers',
        category: 'Footwear',
        price: '\$125.00',
        imageUrl:
            'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=800&q=80',
        rating: 4.9,
        isFavorite: true,
        description: 'Lightweight comfort designed for your daily routine.',
      ),
      FavoriteModel(
        id: 4,
        name: 'Minimal Lamp',
        category: 'Home',
        price: '\$64.00',
        imageUrl:
            'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
        rating: 4.7,
        isFavorite: true,
        description: 'Soft lighting for a calm and modern living space.',
      ),
    ];
  }
}
