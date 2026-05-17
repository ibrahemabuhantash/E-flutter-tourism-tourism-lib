import 'package:flutter/material.dart';
import 'package:tourism/screens/flights/%20flights_screen.dart';
import 'package:tourism/screens/hotels/%20%20hotels_screen.dart';
import 'package:tourism/screens/places/%20places_screen.dart';
import 'package:tourism/screens/restaurants/%20restaurants_screen.dart';
import 'package:tourism/screens/transport/%20ride_request_screen.dart';
import 'package:tourism/widgets/%20%20home_category_card.dart';
import '../../data/app_data.dart';
import '../../widgets/custom_search_field.dart';
import '../../widgets/  home_category_card.dart';
import '../../widgets/place_card.dart';
import '../../widgets/section_title.dart';
import '../flights/ flights_screen.dart';
import '../hotels/  hotels_screen.dart';
import '../places/place_details_screen.dart';
import '../places/ places_screen.dart';
import '../rentals/car_rentals_screen.dart';
import '../restaurants/ restaurants_screen.dart';
import '../transport/ ride_request_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _handleCategoryTap(BuildContext context, String id) {
    switch (id) {
      case 'places':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlacesScreen()),
        );
        break;
      case 'restaurants':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RestaurantsScreen()),
        );
        break;
      case 'cars':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CarRentalsScreen()),
        );
        break;
      case 'cars':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CarRentalsScreen()),
        );
        break;
      case 'rides':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RideRequestScreen()),
        );
        break;
      case 'flights':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FlightsScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('سيتم إضافة هذا القسم قريبًا')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final featuredPlaces = AppData.places.take(2).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل الأردن السياحي'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0E7A6B), Color(0xFF17A589)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اكتشف الأردن بسهولة 🌍',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'أماكن سياحية، مطاعم، فنادق، تأجير سيارات وخدمات أكثر في تطبيق واحد.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const CustomSearchField(
              hintText: 'ابحث عن مكان، مطعم، فندق...',
            ),
            const SizedBox(height: 22),
            const SectionTitle(title: 'الخدمات الرئيسية'),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppData.categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final category = AppData.categories[index];
                return HomeCategoryCard(
                  category: category,
                  onTap: () => _handleCategoryTap(context, category.id),
                );
              },
            ),
            const SizedBox(height: 24),
            SectionTitle(
              title: 'أماكن مميزة',
              actionText: 'عرض الكل',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PlacesScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            ...featuredPlaces.map(
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
          ],
        ),
      ),
    );
  }
}