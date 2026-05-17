class HotelModel {
  final String id;
  final String name;
  final String city;
  final String imageUrl;
  final double rating;
  final double pricePerNight;
  final String type;

  HotelModel({
    required this.id,
    required this.name,
    required this.city,
    required this.imageUrl,
    required this.rating,
    required this.pricePerNight,
    required this.type,
  });
}