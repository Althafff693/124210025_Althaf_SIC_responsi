class Restaurant {
  final String id;
  final String name;
  final String city;
  final String address;
  final double rating;
  final String description;
  final String pictureId;

  Restaurant({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.rating,
    required this.description,
    required this.pictureId,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      address: json['address'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] ?? '',
      pictureId: json['pictureId'],
    );
  }
}
