import 'package:flutter/material.dart';
import '../../models/car_rental_model.dart';
import 'car_booking_screen.dart';

class CarRentalDetailsScreen extends StatelessWidget {
  final CarRentalModel rental;

  const CarRentalDetailsScreen({
    super.key,
    required this.rental,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rental.name),
      ),
      body: ListView(
        children: [
          Image.network(
            rental.imageUrl,
            height: 260,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rental.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        rental.city,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(
                      rental.rating.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'السعر يبدأ من ${rental.pricePerDay.toStringAsFixed(0)} د.أ / يوم',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'الوصف',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  rental.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.indigo),
                    const SizedBox(width: 6),
                    Text(
                      rental.phone,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CarBookingScreen(rental: rental),
                        ),
                      );
                    },
                    icon: const Icon(Icons.car_rental),
                    label: const Text('احجز سيارة الآن'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}