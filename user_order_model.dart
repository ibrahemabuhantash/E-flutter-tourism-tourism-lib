import 'order_item_model.dart';

class UserOrderModel {
  final String id;
  final String type; // food | table_booking | hotel_booking
  final String sourceName;
  final String status;
  final String dateLabel;
  final String? timeLabel;
  final String? address;
  final String? notes;
  final int? guestsCount;
  final double? totalPrice;
  final String? extraLabel;
  final List<OrderItemModel> items;

  UserOrderModel({
    required this.id,
    required this.type,
    required this.sourceName,
    required this.status,
    required this.dateLabel,
    this.timeLabel,
    this.address,
    this.notes,
    this.guestsCount,
    this.totalPrice,
    this.extraLabel,
    this.items = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'sourceName': sourceName,
      'status': status,
      'dateLabel': dateLabel,
      'timeLabel': timeLabel,
      'address': address,
      'notes': notes,
      'guestsCount': guestsCount,
      'totalPrice': totalPrice,
      'extraLabel': extraLabel,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory UserOrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];

    return UserOrderModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      sourceName: json['sourceName'] ?? '',
      status: json['status'] ?? '',
      dateLabel: json['dateLabel'] ?? '',
      timeLabel: json['timeLabel'],
      address: json['address'],
      notes: json['notes'],
      guestsCount: json['guestsCount'],
      totalPrice: json['totalPrice'] == null
          ? null
          : (json['totalPrice'] as num).toDouble(),
      extraLabel: json['extraLabel'],
      items: rawItems
          .map(
            (item) => OrderItemModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),
    );
  }
}
