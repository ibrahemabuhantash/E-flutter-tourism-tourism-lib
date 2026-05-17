import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';
import 'food_order_screen.dart';
import 'table_booking_screen.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: ListView(
        children: [
          Image.network(
            restaurant.imageUrl,
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
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 6),
                    Text(
                      restaurant.rating.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.restaurant_menu, color: Colors.deepOrange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        restaurant.cuisine,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        restaurant.location,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  'الوصف',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  restaurant.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'الخدمات المتوفرة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (restaurant.deliveryAvailable)
                      const Chip(
                        avatar: Icon(Icons.delivery_dining, size: 18),
                        label: Text('توصيل متوفر'),
                      ),
                    if (restaurant.bookingAvailable)
                      const Chip(
                        avatar: Icon(Icons.event_seat, size: 18),
                        label: Text('حجز طاولة متوفر'),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                if (restaurant.bookingAvailable)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TableBookingScreen(
                              restaurant: restaurant,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.event_available),
                      label: const Text('حجز طاولة'),
                    ),
                  ),

                if (restaurant.bookingAvailable)
                  const SizedBox(height: 12),

                if (restaurant.deliveryAvailable)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FoodOrderScreen(
                              restaurant: restaurant,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('طلب طعام'),
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