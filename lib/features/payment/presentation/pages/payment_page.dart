import 'package:flutter/material.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/payment/domain/entities/payment.dart';
import 'package:m2health/features/payment/presentation/widgets/payment_success_dialog.dart';

class PaymentMethod {
  final String id;
  final String type;
  final String displayName;
  final String iconUrl;
  final String code;

  final String? accountNumber;
  final String? expiryDate;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    required this.iconUrl,
    required this.code,
    this.accountNumber,
    this.expiryDate,
  });
}

class PaymentPage extends StatefulWidget {
  final AppointmentEntity appointment;

  const PaymentPage({
    super.key,
    required this.appointment,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? selectedPaymentMethod;

  ProfessionalEntity get profile => widget.appointment.provider!;
  List<AddOnService> get services =>
      widget.appointment.nursingCase!.addOnServices;
  double get totalCost => widget.appointment.payTotal;

  List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: '1',
      type: 'card',
      code: 'Visa',
      displayName: 'Visa',
      iconUrl: 'assets/icons/ic_visa.png',
      accountNumber: '**** **** **** 1234',
      expiryDate: '12/26',
    ),
    PaymentMethod(
      id: '2',
      type: 'card',
      code: 'MasterCard',
      displayName: 'MasterCard',
      iconUrl: 'assets/icons/mastercard.png',
      accountNumber: '**** **** **** 5678',
      expiryDate: '11/25',
    ),
    PaymentMethod(
      id: '3',
      type: 'alipay',
      code: 'Alipay',
      displayName: 'Alipay',
      iconUrl: 'assets/icons/ic_alipay.png',
    ),
    PaymentMethod(
      id: '4',
      type: 'paynow',
      code: 'PayNow',
      displayName: 'PayNow',
      iconUrl: 'assets/icons/ic_paynow.jpg',
    ),
    PaymentMethod(
      id: '5',
      type: 'cash',
      code: 'Cash',
      displayName: 'Cash',
      iconUrl: 'assets/icons/cash.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = selectedPaymentMethod != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withValues(alpha: 0.08),
                    spreadRadius: 0,
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: (profile.avatar != null)
                        ? NetworkImage(profile.avatar!)
                        : null,
                    child: (profile.avatar == null)
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(profile.jobTitle?.toTitleCase() ??
                          profile.role.toTitleCase()),
                      Row(
                        children: [
                          const Icon(Icons.star_half_rounded,
                              color: Color(0xFF9DEAC0)),
                          const SizedBox(width: 4),
                          Text('${profile.rating} (${100} reviews)'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Charge',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              spacing: 4,
              children: [
                ...services.map((service) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(service.name)),
                      Text('\$${service.price}'),
                    ],
                  );
                })
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '\$$totalCost',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              spacing: 8,
              children: paymentMethods
                  .map((method) => _buildPaymentMethodCard(method))
                  .toList(),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isButtonEnabled
              ? () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => PaymentSuccessDialog(
                      appointment: widget.appointment,
                      payment: Payment(
                        // Mock payment data, need to replace with real data after the payment integration
                        id: 0,
                        userId: 0,
                        appointmentId: widget.appointment.id!,
                        method: selectedPaymentMethod!.code,
                        amount: totalCost,
                        status: 'completed',
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF35C5CF),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFB2B9C4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod paymentMethod) {
    void toggleSelection(PaymentMethod newPaymentMethod) {
      setState(() {
        if (selectedPaymentMethod == newPaymentMethod) {
          selectedPaymentMethod = null;
        } else {
          selectedPaymentMethod = newPaymentMethod;
        }
      });
    }

    return GestureDetector(
      onTap: () {
        toggleSelection(paymentMethod);
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedPaymentMethod == paymentMethod
              ? (Colors.green.withValues(alpha: 0.08))
              : Colors.white,
          border: Border.all(
            color: selectedPaymentMethod == paymentMethod
                ? (Colors.green)
                : Colors.grey.withValues(alpha: 0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(paymentMethod.iconUrl, width: 40, height: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentMethod.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (paymentMethod.accountNumber != null) ...[
                    Text(paymentMethod.accountNumber!),
                    Text('Expired: ${paymentMethod.expiryDate}'),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
