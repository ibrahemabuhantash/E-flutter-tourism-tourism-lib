import 'package:flutter/material.dart';
import 'package:tourism/screens/hotels/%20%20hotels_screen.dart';
import 'package:tourism/screens/places/%20places_screen.dart';
import 'package:tourism/screens/profile/%20%20profile_screen.dart';
import 'package:tourism/screens/restaurants/%20restaurants_screen.dart';
import '../home/home_screen.dart';
import '../hotels/  hotels_screen.dart';
import '../places/ places_screen.dart';
import '../profile/  profile_screen.dart';
import '../restaurants/ restaurants_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  late final List<Widget> pages = [
    const HomeScreen(),
    const PlacesScreen(),
    const RestaurantsScreen(),
    const HotelsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: 'الأماكن',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant),
            label: 'المطاعم',
          ),
          NavigationDestination(
            icon: Icon(Icons.hotel_outlined),
            selectedIcon: Icon(Icons.hotel),
            label: 'الفنادق',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'الحساب',
          ),
        ],
      ),
    );
  }
}