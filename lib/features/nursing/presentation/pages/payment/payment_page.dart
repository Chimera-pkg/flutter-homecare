import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/features/nursing/domain/entities/add_on_service.dart';
import 'package:m2health/features/nursing/domain/entities/appointment_entity.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/nursing/domain/entities/payment_method.dart';
import 'package:m2health/features/nursing/domain/entities/professional_entity.dart';
import 'package:m2health/main.dart';
import 'package:m2health/features/appointment/pages/appointment_page.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentPage extends StatefulWidget {
  final AppointmentEntity appointment;
  final NursingCase nursingCase;
  final ProfessionalEntity professional;

  const PaymentPage({
    super.key,
    required this.appointment,
    required this.nursingCase,
    required this.professional,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? selectedPaymentMethod;

  ProfessionalEntity get profile => widget.professional;
  List<AddOnService> get services => widget.nursingCase.addOnServices;
  double get totalCost => widget.nursingCase.estimatedBudget;

  List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: '1',
      type: 'card',
      displayName: 'Visa',
      iconUrl: 'assets/icons/ic_visa.png',
      accountNumber: '**** **** **** 1234',
      expiryDate: '12/26',
    ),
    PaymentMethod(
      id: '2',
      type: 'card',
      displayName: 'MasterCard',
      iconUrl: 'assets/icons/mastercard.png',
      accountNumber: '**** **** **** 5678',
      expiryDate: '11/25',
    ),
    PaymentMethod(
      id: '3',
      type: 'alipay',
      displayName: 'Alipay',
      iconUrl: 'assets/icons/ic_alipay.png',
    ),
    PaymentMethod(
      id: '4',
      type: 'paynow',
      displayName: 'PayNow',
      iconUrl: 'assets/icons/ic_paynow.jpg',
    ),
    PaymentMethod(
      id: '5',
      type: 'cash',
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(profile.avatar ?? ''),
                      onBackgroundImageError: (_, __) {},
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
                        Text(profile.role),
                        Row(
                          children: [
                            const Icon(Icons.star_half, color: Colors.yellow),
                            const SizedBox(width: 4),
                            Text('${profile.rating} (${100} reviews)'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
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
            ...services.map((service) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(service.name),
                  Text('\$${service.price}'),
                ],
              );
            }),
            const Divider(),
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
            const SizedBox(height: 16),
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            ...paymentMethods.map((method) => _buildPaymentMethodCard(method))
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
                    builder: (context) => PaymentSuccessDialog(
                      totalCost: totalCost,
                      pharmacistName: profile.name,
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
      child: Card(
        color: selectedPaymentMethod == paymentMethod
            ? Colors.blue[50]
            : Colors.white,
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

class PaymentSuccessDialog extends StatelessWidget {
  final double totalCost;
  final String pharmacistName;

  const PaymentSuccessDialog(
      {super.key, required this.totalCost, required this.pharmacistName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/ic_checklist.png',
            width: 142,
            height: 142,
          ),
          const SizedBox(height: 16),
          const Text(
            'Payment Success',
            style: TextStyle(
              color: Const.tosca,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your money has been successfully sent to $pharmacistName.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Amount'),
              Text(
                '\$$totalCost',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
            height: 32,
          ),
          const Text(
            'How is your experience?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your feedback will help us to improve your\nexperience better',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FeedbackForm(
                    pharmacistName: pharmacistName,
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Const.tosca,
              minimumSize: const Size(150, 50),
            ),
            child: const Text(
              'Please Feedback',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.read<AppointmentCubit>().refreshAllTabs();
                context.go(AppRoutes.appointment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Const.tosca,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Return to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  final String pharmacistName;

  const FeedbackForm({super.key, required this.pharmacistName});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  int selectedStar = 5;
  String selectedTip = '';
  bool showOtherAmountField = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < selectedStar ? Colors.yellow : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedStar = index + 1;
                      });
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Excellent',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'You rated ${widget.pharmacistName} $selectedStar stars',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Write your text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Give some tips to ${widget.pharmacistName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTipCard('\$1'),
                _buildTipCard('\$2'),
                _buildTipCard('\$5'),
                _buildTipCard('\$10'),
                _buildTipCard('\$20'),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  showOtherAmountField = true;
                });
              },
              child: const Text(
                'Enter other amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (showOtherAmountField) ...[
              const SizedBox(height: 8),
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 353,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FeedbackDetails()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Const.tosca,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                width: 353,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FeedbackDetails()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Const.tosca,
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String amount) {
    bool isSelected = selectedTip == amount;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTip = amount;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Const.tosca : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Const.tosca : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackDetails extends StatelessWidget {
  const FeedbackDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/ic_checklist.png',
              width: 142,
              height: 142,
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you for your feedback',
              style: TextStyle(color: Const.tosca, fontSize: 20),
            ),
            const SizedBox(height: 10),
            const Text(
              'This appointment has been completed and can be viewed in the completed orders menu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    GoRouter.of(context).go(AppRoutes.appointment);
                  },
                  child: const Text(
                    'View Detail',
                    style: TextStyle(color: Const.tosca),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
