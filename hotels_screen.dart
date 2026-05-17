import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/hotel_model.dart';
import '../../widgets/hotel_card.dart';
import 'hotel_details_screen.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<HotelModel> get filteredHotels {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return AppData.hotels;

    return AppData.hotels.where((hotel) {
      return hotel.name.toLowerCase().contains(query) ||
          hotel.city.toLowerCase().contains(query) ||
          hotel.type.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final hotels = filteredHotels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الفنادق والعقارات'),
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
                hintText: 'ابحث عن فندق أو مدينة أو نوع...',
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
            child: hotels.isEmpty
                ? const _SearchEmptyState(
              message: 'لم يتم العثور على فنادق أو عقارات مطابقة للبحث',
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return HotelCard(
                  hotel: hotel,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HotelDetailsScreen(hotel: hotel),
                      ),
                    );
                  },
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
