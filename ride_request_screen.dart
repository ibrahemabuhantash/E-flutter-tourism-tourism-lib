import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/orders_provider.dart';

class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({super.key});

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();
  final notesController = TextEditingController();

  String selectedCarType = 'اقتصادية';
  String selectedPayment = 'نقدًا';
  bool isLoading = false;

  final carTypes = ['اقتصادية', 'عائلية', 'SUV', 'فاخرة'];
  final payments = ['نقدًا', 'بطاقة', 'محفظة إلكترونية'];

  double get estimatedPrice {
    if (pickupController.text.isEmpty ||
        destinationController.text.isEmpty) return 0;

    double base;
    switch (selectedCarType) {
      case 'SUV':
        base = 5;
        break;
      case 'فاخرة':
        base = 8;
        break;
      case 'عائلية':
        base = 4;
        break;
      default:
        base = 2.5;
    }

    return base + ((pickupController.text.length +
        destinationController.text.length) %
        10) *
        0.7;
  }

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    context.read<OrdersProvider>().addRideRequest(
      pickupLocation: pickupController.text.trim(),
      destinationLocation: destinationController.text.trim(),
      carType: selectedCarType,
      paymentMethod: selectedPayment,
      estimatedPrice: estimatedPrice,
      notes: notesController.text.trim(),
    );

    setState(() => isLoading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تم إرسال الطلب'),
        content: Text(
          'من: ${pickupController.text}\n'
              'إلى: ${destinationController.text}\n'
              'نوع السيارة: $selectedCarType\n'
              'السعر التقديري: ${estimatedPrice.toStringAsFixed(2)} د.أ',
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
      appBar: AppBar(title: const Text('طلب سيارة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: pickupController,
                decoration: const InputDecoration(
                  labelText: 'موقع الانطلاق',
                  prefixIcon: Icon(Icons.my_location),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? 'أدخل موقع الانطلاق' : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: destinationController,
                decoration: const InputDecoration(
                  labelText: 'الوجهة',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? 'أدخل الوجهة' : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: selectedCarType,
                decoration: const InputDecoration(
                  labelText: 'نوع السيارة',
                  prefixIcon: Icon(Icons.directions_car),
                ),
                items: carTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedCarType = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: selectedPayment,
                decoration: const InputDecoration(
                  labelText: 'طريقة الدفع',
                  prefixIcon: Icon(Icons.payments),
                ),
                items: payments
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedPayment = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'ملاحظات (اختياري)',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('السعر التقديري'),
                    const Spacer(),
                    Text(
                      '${estimatedPrice.toStringAsFixed(2)} د.أ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : submit,
                  icon: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.local_taxi),
                  label: Text(isLoading ? 'جاري الإرسال...' : 'اطلب سيارة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}