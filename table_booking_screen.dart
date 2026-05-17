import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/restaurant_model.dart';
import '../../providers/orders_provider.dart';

class TableBookingScreen extends StatefulWidget {
  final RestaurantModel restaurant;

  const TableBookingScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<TableBookingScreen> createState() => _TableBookingScreenState();
}

class _TableBookingScreenState extends State<TableBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController guestsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    guestsController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      helpText: 'اختر تاريخ الحجز',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 19, minute: 0),
      helpText: 'اختر وقت الحجز',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '$hour:$minute $period';
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تاريخ الحجز')),
      );
      return;
    }
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار وقت الحجز')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    context.read<OrdersProvider>().addTableBooking(
      restaurantName: widget.restaurant.name,
      dateLabel: _formatDate(selectedDate!),
      timeLabel: _formatTime(selectedTime!),
      guestsCount: int.parse(guestsController.text.trim()),
      notes: notesController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم تأكيد الطلب'),
        content: Text(
          'تم إرسال طلب حجز طاولة في ${widget.restaurant.name}\n'
              'باسم: ${nameController.text.trim()}\n'
              'عدد الأشخاص: ${guestsController.text.trim()}\n'
              'التاريخ: ${_formatDate(selectedDate!)}\n'
              'الوقت: ${_formatTime(selectedTime!)}',
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

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال $label';
    return null;
  }

  String? _validateGuests(String? value) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال عدد الأشخاص';
    final guests = int.tryParse(value.trim());
    if (guests == null || guests <= 0) return 'يرجى إدخال عدد صحيح صالح';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    return Scaffold(
      appBar: AppBar(title: const Text('حجز طاولة')),
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
                        restaurant.imageUrl,
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
                            restaurant.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(restaurant.cuisine,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 18, color: Colors.red),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(restaurant.location,
                                    style:
                                    const TextStyle(color: Colors.grey)),
                              ),
                            ],
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
                    controller: guestsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'عدد الأشخاص',
                      prefixIcon: Icon(Icons.groups),
                    ),
                    validator: _validateGuests,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'تاريخ الحجز',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        selectedDate == null
                            ? 'اختر التاريخ'
                            : _formatDate(selectedDate!),
                        style: TextStyle(
                          color: selectedDate == null
                              ? Colors.grey.shade700
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickTime,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'وقت الحجز',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(
                        selectedTime == null
                            ? 'اختر الوقت'
                            : _formatTime(selectedTime!),
                        style: TextStyle(
                          color: selectedTime == null
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
                            strokeWidth: 2, color: Colors.white),
                      )
                          : const Icon(Icons.event_available),
                      label:
                      Text(isLoading ? 'جاري الإرسال...' : 'تأكيد الحجز'),
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