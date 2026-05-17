import 'package:flutter/material.dart';
import '../../data/app_data.dart';

class FlightsScreen extends StatelessWidget {
  const FlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final offices = AppData.flightOffices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مكاتب الطيران'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: offices.length,
        itemBuilder: (context, index) {
          final office = offices[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      office.imageUrl,
                      width: 95,
                      height: 95,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          office.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${office.city} • ${office.destinationHint}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 18, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(office.rating.toString()),
                          ],
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'سيتم لاحقًا ربط الحجز مع ${office.name}',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.flight_takeoff),
                          label: const Text('احجز رحلة'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}