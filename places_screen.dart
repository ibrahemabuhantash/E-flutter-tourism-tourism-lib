import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/place_model.dart';
import '../../widgets/place_card.dart';
import 'place_details_screen.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<PlaceModel> get filteredPlaces {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return AppData.places;

    return AppData.places.where((place) {
      return place.name.toLowerCase().contains(query) ||
          place.city.toLowerCase().contains(query) ||
          place.location.toLowerCase().contains(query) ||
          place.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final places = filteredPlaces;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأماكن السياحية'),
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
                hintText: 'ابحث عن مكان أو مدينة...',
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
            child: places.isEmpty
                ? const _SearchEmptyState(
              message: 'لم يتم العثور على أماكن مطابقة للبحث',
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return PlaceCard(
                  place: place,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailsScreen(place: place),
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