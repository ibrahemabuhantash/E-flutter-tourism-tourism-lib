import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/car_rental_model.dart';
import 'car_rental_details_screen.dart';

class CarRentalsScreen extends StatefulWidget {
  const CarRentalsScreen({super.key});

  @override
  State<CarRentalsScreen> createState() => _CarRentalsScreenState();
}

class _CarRentalsScreenState extends State<CarRentalsScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<CarRentalModel> get filteredRentals {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return AppData.carRentals;

    return AppData.carRentals.where((rental) {
      return rental.name.toLowerCase().contains(query) ||
          rental.city.toLowerCase().contains(query) ||
          rental.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final rentals = filteredRentals;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تأجير السيارات'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن مكتب أو مدينة...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.close),
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: rentals.isEmpty
                ? const _SearchEmptyState(
              message: 'لم يتم العثور على مكاتب تأجير مطابقة للبحث',
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rentals.length,
              itemBuilder: (context, index) {
                final rental = rentals[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CarRentalDetailsScreen(rental: rental),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                          child: Image.network(
                            rental.imageUrl,
                            height: 185,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rental.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                rental.city,
                                style:
                                const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 18, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(rental.rating.toString()),
                                  const Spacer(),
                                  Text(
                                    '${rental.pricePerDay.toStringAsFixed(0)} د.أ / يوم',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  final String message;

  const _SearchEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 72, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}