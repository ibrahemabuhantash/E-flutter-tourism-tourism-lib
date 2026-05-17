import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/hotel_model.dart';
import '../../providers/orders_provider.dart';

class HotelBookingScreen extends StatefulWidget {
  final HotelModel hotel;

  const HotelBookingScreen({
    super.key,
    required this.hotel,
  });

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController guestsController =
  TextEditingController(text: '2');
  final TextEditingController roomsController =
  TextEditingController(text: '1');
  final TextEditingController notesController = TextEditingController();

  DateTime? checkInDate;
  DateTime? checkOutDate;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    guestsController.dispose();
    roomsController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _pickCheckInDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      helpText: 'اختر تاريخ الدخول',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
    );
    if (picked != null) {
      setState(() {
        checkInDate = picked;
        if (checkOutDate != null && !checkOutDate!.isAfter(picked)) {
          checkOutDate = null;
        }
      });
    }
  }

  Future<void> _pickCheckOutDate() async {
    if (checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر تاريخ الدخول أولاً')),
      );
      return;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: checkInDate!.add(const Duration(days: 1)),
      firstDate: checkInDate!.add(const Duration(days: 1)),
      lastDate: DateTime(checkInDate!.year + 1),
      helpText: 'اختر تاريخ المغادرة',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
    );
    if (picked != null) {
      setState(() {
        checkOutDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
  int get nightsCount =>
      (checkInDate == null || checkOutDate == null)
          ? 0
          : checkOutDate!.difference(checkInDate!).inDays;
  int get roomsCount => int.tryParse(roomsController.text.trim()) ?? 0;
  double get totalPrice =>
      (nightsCount <= 0 || roomsCount <= 0)
          ? 0
          : widget.hotel.pricePerNight * nightsCount * roomsCount;

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال $label';
    return null;
  }

  String? _validatePositiveNumber(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'يرجى إدخال $label';
    final number = int.tryParse(value.trim());
    if (number == null || number <= 0) return 'يرجى إدخال رقم صحيح صالح';
    return null;
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تاريخ الدخول')),
      );
      return;
    }
    if (checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تاريخ المغادرة')),
      );
      return;
    }
    if (nightsCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('عدد الليالي يجب أن يكون يومًا واحدًا على الأقل')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    context.read<OrdersProvider>().addHotelBooking(
      hotelName: widget.hotel.name,
      checkInDate: _formatDate(checkInDate!),
      checkOutDate: _formatDate(checkOutDate!),
      guestsCount: int.parse(guestsController.text.trim()),
      roomsCount: int.parse(roomsController.text.trim()),
      totalPrice: totalPrice,
      notes: notesController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم إرسال الحجز'),
        content: Text(
          'تم إرسال طلب الحجز في ${widget.hotel.name}\n'
              'الدخول: ${_formatDate(checkInDate!)}\n'
              'المغادرة: ${_formatDate(checkOutDate!)}\n'
              'عدد الليالي: $nightsCount\n'
              'عدد الغرف: ${roomsController.text.trim()}\n'
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
    final hotel = widget.hotel;
    return Scaffold(
      appBar: AppBar(title: const Text('حجز فندق')),
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
                        hotel.imageUrl,
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
                          Text(hotel.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('${hotel.city} • ${hotel.type}',
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          Text(
                            '${hotel.pricePerNight.toStringAsFixed(0)} د.أ / ليلة',
                            style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
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
                      labelText: 'عدد النزلاء',
                      prefixIcon: Icon(Icons.groups),
                    ),
                    validator: (value) =>
                        _validatePositiveNumber(value, 'عدد النزلاء'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: roomsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'عدد الغرف',
                      prefixIcon: Icon(Icons.meeting_room),
                    ),
                    validator: (value) =>
                        _validatePositiveNumber(value, 'عدد الغرف'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickCheckInDate,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'تاريخ الدخول',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        checkInDate == null
                            ? 'اختر التاريخ'
                            : _formatDate(checkInDate!),
                        style: TextStyle(
                          color: checkInDate == null
                              ? Colors.grey.shade700
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickCheckOutDate,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'تاريخ المغادرة',
                        prefixIcon: Icon(Icons.logout),
                      ),
                      child: Text(
                        checkOutDate == null
                            ? 'اختر التاريخ'
                            : _formatDate(checkOutDate!),
                        style: TextStyle(
                          color: checkOutDate == null
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
                            const Text('عدد الليالي'),
                            const Spacer(),
                            Text('$nightsCount'),
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
                                  color: Colors.teal),
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
                            strokeWidth: 2, color: Colors.white),
                      )
                          : const Icon(Icons.bed),
                      label: Text(isLoading
                          ? 'جاري إرسال الحجز...'
                          : 'تأكيد الحجز'),
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