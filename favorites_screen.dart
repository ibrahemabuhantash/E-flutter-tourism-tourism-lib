import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_data.dart';
import '../../models/hotel_model.dart';
import '../../models/place_model.dart';
import '../../models/restaurant_model.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/hotel_card.dart';
import '../../widgets/place_card.dart';
import '../../widgets/restaurant_card.dart';
import '../hotels/hotel_details_screen.dart';
import '../places/place_details_screen.dart';
import '../restaurants/restaurant_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();

    final favoritePlaces = _favoritePlaces(favoritesProvider.placeIds);
    final favoriteRestaurants =
    _favoriteRestaurants(favoritesProvider.restaurantIds);
    final favoriteHotels = _favoriteHotels(favoritesProvider.hotelIds);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
        actions: [
          if (!favoritesProvider.isEmpty)
            IconButton(
              onPressed: () {
                favoritesProvider.clearFavorites();
              },
              icon: const Icon(Icons.delete_outline),
              tooltip: 'مسح المفضلة',
            ),
        ],
      ),
      body: favoritesProvider.isEmpty
          ? const _FavoritesEmptyState()
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (favoritePlaces.isNotEmpty) ...[
            const _SectionTitle(title: 'الأماكن السياحية'),
            const SizedBox(height: 12),
            ...favoritePlaces.map(
                  (place) => PlaceCard(
                place: place,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailsScreen(place: place),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (favoriteRestaurants.isNotEmpty) ...[
            const _SectionTitle(title: 'المطاعم'),
            const SizedBox(height: 12),
            ...favoriteRestaurants.map(
                  (restaurant) => RestaurantCard(
                restaurant: restaurant,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailsScreen(
                        restaurant: restaurant,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (favoriteHotels.isNotEmpty) ...[
            const _SectionTitle(title: 'الفنادق والعقارات'),
            const SizedBox(height: 12),
            ...favoriteHotels.map(
                  (hotel) => HotelCard(
                hotel: hotel,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HotelDetailsScreen(hotel: hotel),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<PlaceModel> _favoritePlaces(List<String> ids) {
    return AppData.places.where((item) => ids.contains(item.id)).toList();
  }

  List<RestaurantModel> _favoriteRestaurants(List<String> ids) {
    return AppData.restaurants.where((item) => ids.contains(item.id)).toList();
  }

  List<HotelModel> _favoriteHotels(List<String> ids) {
    return AppData.hotels.where((item) => ids.contains(item.id)).toList();
  }
}

class _FavoritesEmptyState extends StatelessWidget {
  const _FavoritesEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.favorite_border, size: 84, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'لا توجد عناصر في المفضلة بعد',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'أضف المطاعم أو الفنادق أو الأماكن السياحية إلى المفضلة لتظهر هنا.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
