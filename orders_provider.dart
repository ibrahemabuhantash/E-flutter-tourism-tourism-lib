import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_item_model.dart';
import '../models/user_order_model.dart';

class OrdersProvider extends ChangeNotifier {
  static const String _storageKey = 'saved_orders';

  final List<UserOrderModel> _orders = [];

  OrdersProvider() {
    _loadOrders();
  }

  List<UserOrderModel> get orders => List.unmodifiable(_orders.reversed);

  void addFoodOrder({
    required String restaurantName,
    required String address,
    required String notes,
    required double totalPrice,
    required List<OrderItemModel> items,
  }) {
    _orders.add(
      UserOrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'food',
        sourceName: restaurantName,
        status: 'قيد التحضير',
        dateLabel: _formatDate(DateTime.now()),
        address: address,
        notes: notes.isEmpty ? null : notes,
        totalPrice: totalPrice,
        items: items,
      ),
    );
    _saveOrders();
    notifyListeners();
  }

  void addTableBooking({
    required String restaurantName,
    required String dateLabel,
    required String timeLabel,
    required int guestsCount,
    required String notes,
  }) {
    _orders.add(
      UserOrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'table_booking',
        sourceName: restaurantName,
        status: 'بانتظار التأكيد',
        dateLabel: dateLabel,
        timeLabel: timeLabel,
        guestsCount: guestsCount,
        notes: notes.isEmpty ? null : notes,
      ),
    );
    _saveOrders();
    notifyListeners();
  }

  void addHotelBooking({
    required String hotelName,
    required String checkInDate,
    required String checkOutDate,
    required int guestsCount,
    required int roomsCount,
    required double totalPrice,
    required String notes,
  }) {
    _orders.add(
      UserOrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'hotel_booking',
        sourceName: hotelName,
        status: 'بانتظار التأكيد',
        dateLabel: checkInDate,
        timeLabel: checkOutDate,
        guestsCount: guestsCount,
        totalPrice: totalPrice,
        notes: notes.isEmpty ? null : notes,
        extraLabel: 'عدد الغرف: $roomsCount',
      ),
    );
    _saveOrders();
    notifyListeners();
  }

  void addCarRentalBooking({
    required String officeName,
    required String pickupDate,
    required String returnDate,
    required int daysCount,
    required String carType,
    required String pickupCity,
    required String notes,
    required double totalPrice,
  }) {
    _orders.add(
      UserOrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'car_booking',
        sourceName: officeName,
        status: 'بانتظار التأكيد',
        dateLabel: pickupDate,
        timeLabel: returnDate,
        totalPrice: totalPrice,
        notes: notes.isEmpty ? null : notes,
        extraLabel: 'السيارة: $carType • المدينة: $pickupCity • الأيام: $daysCount',
      ),
    );void addRideRequest({
      required String pickupLocation,
      required String destinationLocation,
      required String carType,
      required String paymentMethod,
      required double estimatedPrice,
      required String notes,
    }) {
      _orders.add(
        UserOrderModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'ride_request',
          sourceName: 'طلب سيارة',
          status: 'بانتظار السائق',
          dateLabel: _formatDate(DateTime.now()),
          address: 'من $pickupLocation إلى $destinationLocation',
          totalPrice: estimatedPrice,
          notes: notes.isEmpty ? null : notes,
          extraLabel: 'نوع السيارة: $carType • الدفع: $paymentMethod',
        ),
      );

      _saveOrders();
      notifyListeners();
    }
    _saveOrders();
    notifyListeners();
  }void addRideRequest({
    required String pickupLocation,
    required String destinationLocation,
    required String carType,
    required String paymentMethod,
    required double estimatedPrice,
    required String notes,
  }) {
    _orders.add(
      UserOrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'ride_request',
        sourceName: 'طلب سيارة',
        status: 'بانتظار السائق',
        dateLabel: _formatDate(DateTime.now()),
        address: 'من $pickupLocation إلى $destinationLocation',
        totalPrice: estimatedPrice,
        notes: notes.isEmpty ? null : notes,
        extraLabel: 'نوع السيارة: $carType • الدفع: $paymentMethod',
      ),
    );

    _saveOrders();
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    _saveOrders();
    notifyListeners();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedOrders = _orders.map((order) => jsonEncode(order.toJson())).toList();
    await prefs.setStringList(_storageKey, encodedOrders);
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final storedOrders = prefs.getStringList(_storageKey) ?? [];

    final decodedOrders = storedOrders
        .map((orderString) => UserOrderModel.fromJson(jsonDecode(orderString)))
        .toList();

    _orders
      ..clear()
      ..addAll(decodedOrders);

    notifyListeners();
  }
}