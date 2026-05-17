import '../models/order_item_model.dart';
import '../models/user_order_model.dart';

class OrdersService {
  OrdersService._privateConstructor();

  static final OrdersService instance = OrdersService._privateConstructor();

  final List<UserOrderModel> _orders = [];

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
  }

  void clearOrders() {
    _orders.clear();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
