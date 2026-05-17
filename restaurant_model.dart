class RestaurantModel {
  final String id;
  final String name;
  final String city;
  final String cuisine;
  final String description;
  final String location;
  final String imageUrl;
  final double rating;
  final bool deliveryAvailable;
  final bool bookingAvailable;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.city,
    required this.cuisine,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.deliveryAvailable,
    required this.bookingAvailable,
  });
}