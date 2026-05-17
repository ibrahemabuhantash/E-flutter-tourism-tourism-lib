import 'package:flutter/material.dart';
import 'package:tourism/core/constants/%20app_colors.dart';
import 'package:tourism/models/flight_office_model.dart%20%E2%94%82.dart';
import '../core/constants/ app_colors.dart';
import '../models/car_rental_model.dart';
import '../models/flight_office_model.dart │.dart';
import '../models/hotel_model.dart';
import '../models/place_model.dart';
import '../models/restaurant_model.dart';
import '../models/service_category_model.dart';
import '../models/car_rental_model.dart';
class AppData {
  static List<ServiceCategoryModel> categories = [
    ServiceCategoryModel(
      id: 'places',
      title: 'أماكن سياحية',
      icon: Icons.travel_explore,
      color: AppColors.primary,
    ),
    ServiceCategoryModel(
      id: 'restaurants',
      title: 'مطاعم',
      icon: Icons.restaurant,
      color: Colors.deepOrange,
    ),
    ServiceCategoryModel(
      id: 'hotels',
      title: 'فنادق',
      icon: Icons.hotel,
      color: Colors.indigo,
    ),
    ServiceCategoryModel(
      id: 'cars',
      title: 'تأجير سيارات',
      icon: Icons.car_rental,
      color: Colors.teal,
    ),
    ServiceCategoryModel(
      id: 'rides',
      title: 'طلب سيارة',
      icon: Icons.local_taxi,
      color: Colors.amber,
    ),
    ServiceCategoryModel(
      id: 'flights',
      title: 'طيران',
      icon: Icons.flight_takeoff,
      color: Colors.blue,
    ),
  ];

  static List<PlaceModel> places = [
    PlaceModel(
      id: '1',
      name: 'البتراء',
      city: 'معان',
      description:
      'مدينة أثرية منحوتة في الصخور الوردية، وتُعد من أشهر الوجهات السياحية في الأردن والعالم.',
      imageUrl:
      'https://images.unsplash.com/photo-1579606032821-4e6161c81bd0?auto=format&fit=crop&w=1200&q=80',
      rating: 4.9,
      location: 'البتراء، الأردن',
    ),
    PlaceModel(
      id: '2',
      name: 'وادي رم',
      city: 'العقبة',
      description:
      'صحراء ساحرة بتكوينات صخرية مدهشة، مناسبة للتخييم والرحلات الصحراوية والمغامرات.',
      imageUrl:
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
      location: 'وادي رم، الأردن',
    ),
    PlaceModel(
      id: '3',
      name: 'جرش',
      city: 'جرش',
      description:
      'مدينة أثرية رومانية مميزة تحتوي على شوارع أعمدة ومسارح وآثار تاريخية رائعة.',
      imageUrl:
      'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
      location: 'جرش، الأردن',
    ),
  ];

  static List<RestaurantModel> restaurants = [
    RestaurantModel(
      id: '1',
      name: 'مطعم هاشم',
      city: 'عمّان',
      cuisine: 'مأكولات شعبية',
      description:
      'يُعتبر من أشهر المطاعم الشعبية في عمّان، ويشتهر بتقديم الفول والحمص والفلافل بجودة عالية وأسعار مناسبة.',
      location: 'وسط البلد، عمّان',
      imageUrl:
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
      deliveryAvailable: true,
      bookingAvailable: false,
    ),
    RestaurantModel(
      id: '2',
      name: 'مطعم فخر الدين',
      city: 'عمّان',
      cuisine: 'مأكولات عربية فاخرة',
      description:
      'مطعم راقٍ يقدم تجربة طعام عربية مميزة مع أجواء هادئة وخدمة ممتازة، وهو مناسب للعائلات والضيوف والسياح.',
      location: 'جبل عمّان، عمّان',
      imageUrl:
      'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=1200&q=80',
      rating: 4.6,
      deliveryAvailable: true,
      bookingAvailable: true,
    ),
    RestaurantModel(
      id: '3',
      name: 'مطعم صفصفا',
      city: 'العقبة',
      cuisine: 'مأكولات شرقية ولبنانية',
      description:
      'مطعم يقدم أطباقًا شرقية ومشاوي ومقبلات متنوعة، مع جلسات مريحة وخيارات مناسبة للحجوزات والطلبات.',
      location: 'العقبة، الأردن',
      imageUrl:
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=80',
      rating: 4.7,
      deliveryAvailable: false,
      bookingAvailable: true,
    ),
  ];

  static List<HotelModel> hotels = [
    HotelModel(
      id: '1',
      name: 'فندق البتراء الملكي',
      city: 'معان',
      imageUrl:
      'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80',
      rating: 4.5,
      pricePerNight: 85,
      type: 'فندق',
    ),
    HotelModel(
      id: '2',
      name: 'شقق البحر الميت',
      city: 'البحر الميت',
      imageUrl:
      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1200&q=80',
      rating: 4.3,
      pricePerNight: 60,
      type: 'شقق',
    ),
    HotelModel(
      id: '3',
      name: 'منتجع العقبة السياحي',
      city: 'العقبة',
      imageUrl:
      'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80',
      rating: 4.8,
      pricePerNight: 120,
      type: 'منتجع',
    ),
  ];

  static List<CarRentalModel> carRentals = [
    CarRentalModel(
      id: '1',
      name: 'مكتب الأردن لتأجير السيارات',
      city: 'عمّان',
      imageUrl:
      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1200&q=80',
      rating: 4.5,
      pricePerDay: 25,
      phone: '+962790000001',
      description:
      'مكتب موثوق لتأجير السيارات داخل الأردن، يوفر سيارات اقتصادية وعائلية وسيارات SUV مع خيارات استلام مرنة وأسعار يومية مناسبة.',
    ),
    CarRentalModel(
      id: '2',
      name: 'مكتب الرحالة',
      city: 'العقبة',
      imageUrl:
      'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?auto=format&fit=crop&w=1200&q=80',
      rating: 4.3,
      pricePerDay: 30,
      phone: '+962790000002',
      description:
      'يوفر سيارات مناسبة للسياح والمسافرين مع خدمة دعم جيدة وخيارات متعددة للحجز والاستلام من العقبة أو المدن القريبة.',
    ),
    CarRentalModel(
      id: '3',
      name: 'مكتب المسار الآمن',
      city: 'إربد',
      imageUrl:
      'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=1200&q=80',
      rating: 4.6,
      pricePerDay: 28,
      phone: '+962790000003',
      description:
      'خدمة تأجير سيارات يومية وأسبوعية مع عروض خاصة للرحلات الطويلة وخيارات متعددة من السيارات الحديثة.',
    ),
  ];

  static List<FlightOfficeModel> flightOffices = [
    FlightOfficeModel(
      id: '1',
      name: 'مكتب الأفق للسفر والطيران',
      city: 'عمّان',
      imageUrl:
      'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&w=1200&q=80',
      rating: 4.4,
      destinationHint: 'رحلات من وإلى الأردن',
      phone: '+962790000010',
    ),
    FlightOfficeModel(
      id: '2',
      name: 'مكتب بوابة المسافر',
      city: 'إربد',
      imageUrl:
      'https://images.unsplash.com/photo-1517479149777-5f3b1511d5ad?auto=format&fit=crop&w=1200&q=80',
      rating: 4.2,
      destinationHint: 'حجوزات طيران دولية ومحلية',
      phone: '+962790000011',
    ),
  ];
}