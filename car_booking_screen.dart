import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/car_rental_model.dart';
import '../../providers/orders_provider.dart';

class CarBookingScreen extends StatefulWidget {
  final CarRentalModel rental;

  const CarBookingScreen({
    super.key,
    required this.rental,
  });

  @override
  State<CarBookingScreen> createState() => _CarBookingScreenState();
}

class _CarBookingScreenState extends State<CarBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pickupCityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime? pickupDate;
  DateTime? returnDate;
  String selectedCarType = 'اقتصادية';
  bool isLoading = false;

  final List<String> carTypes = ['اقتصادية', 'عائلية', 'SUV', 'فاخرة'];

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    pickupCityController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _pickPickupDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      helpText: 'اختر تاريخ الاستلام',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
    );

    if (picked != null) {
      setState(() {
        pickupDate = picked;
        if (returnDate != null && !returnDate!.isAfter(picked)) {
          returnDate = null;
        }
      });
    }
  }

  Future<void> _pickReturnDate() async {
    if (pickupDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر تاريخ الاستلام أولاً')),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: pickupDate!.add(const Duration(days: 1)),
      firstDate: pickupDate!.add(const Duration(days: 1)),
      lastDate: DateTime(pickupDate!.year + 1),
      helpText: 'اختر تاريخ الإرجاع',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
    );

    if (picked != null) {
      setState(() {
        returnDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int get daysCount {
    if (pickupDate == null || returnDate == null) return 0;
    return returnDate!.difference(pickupDate!).inDays;
  }

  double get totalPrice {
    if (daysCount <= 0) return 0;
    return widget.rental.pricePerDay * daysCount;
  }

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال $label';
    }
    return null;
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    if (pickupDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تاريخ الاستلام')),
      );
      return;
    }

    if (returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تاريخ الإرجاع')),
      );
      return;
    }

    if (daysCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('مدة الإيجار يجب أن تكون يومًا واحدًا على الأقل'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    context.read<OrdersProvider>().addCarRentalBooking(
      officeName: widget.rental.name,
      pickupDate: _formatDate(pickupDate!),
      returnDate: _formatDate(returnDate!),
      daysCount: daysCount,
      carType: selectedCarType,
      pickupCity: pickupCityController.text.trim(),
      notes: notesController.text.trim(),
      totalPrice: totalPrice,
    );

    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم إرسال طلب الحجز'),
        content: Text(
          'تم إرسال طلب استئجار سيارة من ${widget.rental.name}\n'
              'نوع السيارة: $selectedCarType\n'
              'الاستلام: ${_formatDate(pickupDate!)}\n'
              'الإرجاع: ${_formatDate(returnDate!)}\n'
              'عدد الأيام: $daysCount\n'
              'الإجمالي: ${totalPrice.toStringAsFixed(2)} د.أ',
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
    final rental = widget.rental;

    return Scaffold(
      appBar: AppBar(
        title: const Text('حجز سيارة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                        rental.imageUrl,
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
                            rental.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            rental.city,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${rental.pricePerDay.toStringAsFixed(0)} د.أ / يوم',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم الكامل',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                        _validateRequired(value, 'الاسم الكامل'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'رقم الهاتف',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) =>
                        _validateRequired(value, 'رقم الهاتف'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: pickupCityController,
                    decoration: const InputDecoration(
                      labelText: 'مدينة الاستلام',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (value) =>
                        _validateRequired(value, 'مدينة الاستلام'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCarType,
                    decoration: const InputDecoration(
                      labelText: 'نوع السيارة',
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                    items: carTypes
                        .map(
                          (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCarType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickPickupDate,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'تاريخ الاستلام',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        pickupDate == null
                            ? 'اختر التاريخ'
                            : _formatDate(pickupDate!),
                        style: TextStyle(
                          color: pickupDate == null
                              ? Colors.grey.shade700
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickReturnDate,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'تاريخ الإرجاع',
                        prefixIcon: Icon(Icons.event_repeat),
                      ),
                      child: Text(
                        returnDate == null
                            ? 'اختر التاريخ'
                            : _formatDate(returnDate!),
                        style: TextStyle(
                          color: returnDate == null
                              ? Colors.grey.shade700
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'ملاحظات إضافية (اختياري)',
                      prefixIcon: Icon(Icons.note_alt_outlined),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('عدد الأيام'),
                            const Spacer(),
                            Text('$daysCount'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('الإجمالي المتوقع'),
                            const Spacer(),
                            Text(
                              '${totalPrice.toStringAsFixed(2)} د.أ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _submitBooking,
                      icon: isLoading
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.car_rental),
                      label: Text(
                        isLoading ? 'جاري إرسال الحجز...' : 'تأكيد الحجز',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}