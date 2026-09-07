class LocationModel {
  const LocationModel({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String address;
  final double latitude;
  final double longitude;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: (json['address'] ?? json['formatted_address'] ?? 'Unknown address')
          .toString(),
      latitude: double.tryParse((json['latitude'] ?? json['lat'])?.toString() ?? '') ?? 0,
      longitude: double.tryParse((json['longitude'] ?? json['lng'])?.toString() ?? '') ?? 0,
    );
  }
}
