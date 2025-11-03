import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/route/app_routes.dart';

class PaymentPage extends StatefulWidget {
  final int appointmentId;
  final Map<String, dynamic> profileServiceData;

  const PaymentPage({super.key, required this.appointmentId, required this.profileServiceData});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = '';

  final List<Map<String, dynamic>> services = [
    {'name': 'Inject', 'cost': 250},
    {'name': 'Blood Glucose Check', 'cost': 65},
  ];

  int get totalCost {
    return services.fold(0, (sum, service) => sum + service['cost'] as int);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> profile = widget.profileServiceData;

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
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          profile['avatar'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/images_budi.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(profile['role']),
                        Row(
                          children: [
                            const Icon(Icons.star_half, color: Colors.yellow),
                            const SizedBox(width: 4),
                            Text(
                                '${profile['rating']} (${profile['reviews']} reviews)'),
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
                  Text(service['name']),
                  Text('\$${service['cost']}'),
                ],
              );
            }).toList(),
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
            _buildPaymentMethodCard('Visa', '**** **** **** 1234', '12/26',
                'assets/icons/ic_visa.png'),
            _buildPaymentMethodCard('MasterCard', '**** **** **** 5678',
                '11/25', 'assets/icons/mastercard.png'),
            _buildPaymentMethodCard('Alipay', '**** **** **** 9012', '10/24',
                'assets/icons/ic_alipay.png'),
            _buildPaymentMethodCard('PayNow', '**** **** **** 9012', '10/24',
                'assets/icons/ic_paynow.jpg'),
            _buildPaymentMethodCard(
                'Cash', ' ', '12/26', 'assets/icons/cash.png'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PaymentSuccessDialog(
                  totalCost: totalCost,
                  pharmacistName: profile['name'],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Const.tosca, // Set the button color to Const.tosca
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
      String method, String accountNumber, String expiryDate, String iconPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Card(
        color: selectedPaymentMethod == method ? Colors.blue[50] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(iconPath, width: 40, height: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (accountNumber.isNotEmpty) ...[
                    Text(accountNumber),
                    Text('Expired: $expiryDate'),
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
  final int totalCost;
  final String pharmacistName;

  const PaymentSuccessDialog({super.key, required this.totalCost, required this.pharmacistName});

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
            'assets/icons/ic_checklist.png', // Replace with your actual image path
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
              backgroundColor:
                  Const.tosca, // Set the button color to Const.tosca
              minimumSize:
                  const Size(150, 50), // Customize the width and height
            ),
            child: const Text(
              'Please Feedback',
              style:
                  TextStyle(color: Colors.white), // Set the text color to white
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.go(AppRoutes.appointment);
                context.read<AppointmentCubit>().refreshAllTabs();
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
                width: 353, // Set the width to 353
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedbackDetails()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Const.tosca, // Set the button color to Const.tosca
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
                width: 353, // Set the width to 353
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedbackDetails()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Const.tosca, // Set the button color to Const.tosca
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
        // title: Text('Feedback'),
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
              'assets/icons/ic_checklist.png', // Replace with your actual image path
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
                    style: TextStyle(
                        color: Const.tosca), // Set the text color to white
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
