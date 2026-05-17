class CarRentalModel {
  final String id;
  final String name;
  final String city;
  final String imageUrl;
  final double rating;
  final double pricePerDay;
  final String phone;
  final String description;

  CarRentalModel({
    required this.id,
    required this.name,
    required this.city,
    required this.imageUrl,
    required this.rating,
    required this.pricePerDay,
    required this.phone,
    required this.description,
  });
}