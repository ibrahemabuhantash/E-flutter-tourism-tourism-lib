import 'package:flutter/material.dart';
import '../../models/hotel_model.dart';
import 'hotel_booking_screen.dart';

class HotelDetailsScreen extends StatelessWidget {
  final HotelModel hotel;

  const HotelDetailsScreen({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name),
      ),
      body: ListView(
        children: [
          Image.network(
            hotel.imageUrl,
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
                  hotel.name,
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
                        hotel.city,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.home_work, color: Colors.indigo),
                    const SizedBox(width: 6),
                    Text(
                      hotel.type,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(
                      hotel.rating.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'السعر: ${hotel.pricePerNight.toStringAsFixed(0)} د.أ / ليلة',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HotelBookingScreen(hotel: hotel),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bed),
                    label: const Text('احجز الآن'),
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