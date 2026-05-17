import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_order_model.dart';
import '../../providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي'),
        actions: [
          if (orders.isNotEmpty)
            IconButton(
              onPressed: () {
                context.read<OrdersProvider>().clearOrders();
              },
              icon: const Icon(Icons.delete_outline),
              tooltip: 'مسح الكل',
            ),
        ],
      ),
      body: orders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _OrderCard(order: order);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'لا توجد طلبات أو حجوزات حتى الآن',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'عند طلب الطعام أو حجز طاولة أو حجز فندق أو استئجار سيارة ستظهر هنا جميع الطلبات الخاصة بك.',
              style: TextStyle(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final UserOrderModel order;

  const _OrderCard({required this.order});

  String get orderTitle {
    switch (order.type) {
      case 'food':
        return 'طلب طعام';
      case 'table_booking':
        return 'حجز طاولة';
      case 'hotel_booking':
        return 'حجز فندق';
      case 'car_booking':
        return 'استئجار سيارة';
      case 'ride_request':
        return 'طلب سيارة';
      default:
        return 'طلب';
    }
  }

  IconData get orderIcon {
    switch (order.type) {
      case 'food':
        return Icons.shopping_bag;
      case 'table_booking':
        return Icons.event_seat;
      case 'hotel_booking':
        return Icons.hotel;
      case 'car_booking':
        return Icons.car_rental;
      case 'ride_request':
        return Icons.local_taxi;
      default:
        return Icons.receipt_long;
    }
  }

  Color get accentColor {
    switch (order.type) {
      case 'food':
        return Colors.deepOrange;
      case 'table_booking':
        return Colors.indigo;
      case 'hotel_booking':
        return Colors.teal;
      case 'car_booking':
        return Colors.blueGrey;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: accentColor.withOpacity(0.12),
                  child: Icon(orderIcon, color: accentColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(order.sourceName,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                        color: accentColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.calendar_today,
              label: order.type == 'hotel_booking'
                  ? 'تاريخ الدخول'
                  : order.type == 'car_booking'
                  ? 'تاريخ الاستلام'
                  : 'التاريخ',
              value: order.dateLabel,
            ),
            if (order.timeLabel != null)
              _InfoRow(
                icon: order.type == 'hotel_booking'
                    ? Icons.logout
                    : order.type == 'car_booking'
                    ? Icons.event_repeat
                    : Icons.access_time,
                label: order.type == 'hotel_booking'
                    ? 'تاريخ المغادرة'
                    : order.type == 'car_booking'
                    ? 'تاريخ الإرجاع'
                    : 'الوقت',
                value: order.timeLabel!,
              ),
            if (order.address != null)
              _InfoRow(
                  icon: Icons.location_on,
                  label: 'العنوان',
                  value: order.address!),
            if (order.guestsCount != null)
              _InfoRow(
                icon: Icons.groups,
                label: order.type == 'hotel_booking'
                    ? 'عدد النزلاء'
                    : 'عدد الأشخاص',
                value: order.guestsCount.toString(),
              ),
            if (order.extraLabel != null)
              _InfoRow(
                  icon: Icons.info_outline,
                  label: 'تفاصيل إضافية',
                  value: order.extraLabel!),
            if (order.notes != null && order.notes!.trim().isNotEmpty)
              _InfoRow(
                  icon: Icons.note_alt_outlined,
                  label: 'ملاحظات',
                  value: order.notes!),
            if (order.items.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text(
                'الأصناف',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...order.items.map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(child: Text('${item.quantity} × ${item.title}')),
                      Text('${item.price.toStringAsFixed(2)} د.أ'),
                    ],
                  ),
                ),
              ),
            ],
            if (order.totalPrice != null) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Text('الإجمالي',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(
                    '${order.totalPrice!.toStringAsFixed(2)} د.أ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: accentColor),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}