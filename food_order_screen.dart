import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_item_model.dart';
import '../../models/restaurant_model.dart';
import '../../providers/orders_provider.dart';

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}

class FoodOrderScreen extends StatefulWidget {
  final RestaurantModel restaurant;

  const FoodOrderScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<FoodOrderScreen> createState() => _FoodOrderScreenState();
}

class _FoodOrderScreenState extends State<FoodOrderScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final List<MenuItem> menuItems = [
    MenuItem(
      id: '1',
      name: 'وجبة مشاوي مشكلة',
      description: 'لحم وكباب ودجاج مع خبز ومقبلات',
      price: 8.50,
    ),
    MenuItem(
      id: '2',
      name: 'شاورما دجاج',
      description: 'ساندويش شاورما مع بطاطا وصوص الثوم',
      price: 3.25,
    ),
    MenuItem(
      id: '3',
      name: 'حمص وفلافل',
      description: 'وجبة شعبية مع خبز طازج ومخللات',
      price: 2.75,
    ),
    MenuItem(
      id: '4',
      name: 'مشروب غازي',
      description: 'عبوة 330 مل',
      price: 0.75,
    ),
  ];

  final Map<String, int> quantities = {};
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    for (final item in menuItems) {
      quantities[item.id] = 0;
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void incrementItem(String itemId) {
    setState(() {
      quantities[itemId] = (quantities[itemId] ?? 0) + 1;
    });
  }

  void decrementItem(String itemId) {
    if ((quantities[itemId] ?? 0) <= 0) return;
    setState(() {
      quantities[itemId] = (quantities[itemId] ?? 0) - 1;
    });
  }

  int get totalItems => quantities.values.fold(0, (sum, qty) => sum + qty);

  double get subtotal {
    double total = 0;
    for (final item in menuItems) {
      total += item.price * (quantities[item.id] ?? 0);
    }
    return total;
  }

  double get deliveryFee => totalItems > 0 ? 1.50 : 0;
  double get totalPrice => subtotal + deliveryFee;

  Future<void> submitOrder() async {
    if (totalItems == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار صنف واحد على الأقل')),
      );
      return;
    }

    if (addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال عنوان التوصيل')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final selectedItems = menuItems
        .where((item) => (quantities[item.id] ?? 0) > 0)
        .map(
          (item) => OrderItemModel(
        title: item.name,
        quantity: quantities[item.id] ?? 0,
        price: item.price * (quantities[item.id] ?? 0),
      ),
    )
        .toList();

    context.read<OrdersProvider>().addFoodOrder(
      restaurantName: widget.restaurant.name,
      address: addressController.text.trim(),
      notes: notesController.text.trim(),
      totalPrice: totalPrice,
      items: selectedItems,
    );

    setState(() {
      isSubmitting = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم تأكيد الطلب'),
        content: Text(
          'تم إرسال طلبك من ${widget.restaurant.name}\n'
              'عدد الأصناف: $totalItems\n'
              'الإجمالي: ${totalPrice.toStringAsFixed(2)} د.أ\n'
              'العنوان: ${addressController.text.trim()}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب طعام')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.restaurant.imageUrl,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.restaurant.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.restaurant.cuisine,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 18, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(widget.restaurant.rating.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Text(
                  'اختر الأصناف',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...menuItems.map(
                      (item) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.description,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${item.price.toStringAsFixed(2)} د.أ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => decrementItem(item.id),
                                icon:
                                const Icon(Icons.remove_circle_outline),
                              ),
                              Text(
                                '${quantities[item.id] ?? 0}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () => incrementItem(item.id),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                              const Spacer(),
                              if ((quantities[item.id] ?? 0) > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'المجموع: ${((quantities[item.id] ?? 0) * item.price).toStringAsFixed(2)} د.أ',
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'عنوان التوصيل',
                    hintText: 'مثال: عمّان - الجبيهة - شارع الجامعة',
                    prefixIcon: Icon(Icons.location_on),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظات إضافية (اختياري)',
                    hintText: 'مثال: بدون بصل، اتصل قبل الوصول...',
                    prefixIcon: Icon(Icons.note_alt_outlined),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text('المجموع الفرعي'),
                      const Spacer(),
                      Text('${subtotal.toStringAsFixed(2)} د.أ'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('رسوم التوصيل'),
                      const Spacer(),
                      Text('${deliveryFee.toStringAsFixed(2)} د.أ'),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Text('الإجمالي',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} د.أ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting ? null : submitOrder,
                      icon: isSubmitting
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                          : const Icon(Icons.shopping_bag),
                      label: Text(
                          isSubmitting ? 'جاري إرسال الطلب...' : 'تأكيد الطلب'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}