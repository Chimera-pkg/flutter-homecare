import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/main.dart';
import 'package:m2health/features/appointment/pages/appointment_page.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/core/presentation/widgets/bottombar.dart';

class RadiologistPaymentPage extends StatefulWidget {
  final int appointmentId;
  final Map<String, dynamic> profileServiceData;

  RadiologistPaymentPage(
      {required this.appointmentId, required this.profileServiceData});

  @override
  _RadiologistPaymentPageState createState() => _RadiologistPaymentPageState();
}

class _RadiologistPaymentPageState extends State<RadiologistPaymentPage> {
  String selectedPaymentMethod = '';

  final List<Map<String, dynamic>> services = [
    {'name': 'CT Scan Analysis', 'cost': 200},
    {'name': 'Image Interpretation', 'cost': 150},
    {'name': 'Report Generation', 'cost': 50},
  ];

  int get totalCost {
    return services.fold(0, (sum, service) => sum + service['cost'] as int);
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profileServiceData;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
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
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: (profile['avatar'] != null &&
                              profile['avatar'].toString().isNotEmpty)
                          ? NetworkImage(profile['avatar'])
                          : null,
                      child: (profile['avatar'] == null ||
                              profile['avatar'].toString().isEmpty)
                          ? Icon(Icons.person,
                              size: 30, color: Colors.grey[600])
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${profile['name'] ?? 'Radiologist'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Radiology Specialist'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.yellow, size: 16),
                            const Icon(Icons.star,
                                color: Colors.yellow, size: 16),
                            const Icon(Icons.star,
                                color: Colors.yellow, size: 16),
                            const Icon(Icons.star,
                                color: Colors.yellow, size: 16),
                            const Icon(Icons.star_half, color: Colors.yellow),
                            const SizedBox(width: 4),
                            Text(
                                '${profile['rating'] ?? '4.8'} (${profile['reviews'] ?? '156'} reviews)'),
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
              'Service Breakdown',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            ...services.map((service) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(service['name']),
                    Text('\$${service['cost']}'),
                  ],
                ),
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
                    color: Color(0xFF35C5CF),
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
                return RadiologistPaymentSuccessDialog(
                  totalCost: totalCost,
                  radiologistName: profile['name'] ?? 'Radiologist',
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Const.tosca,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Confirm Payment',
            style: TextStyle(color: Colors.white, fontSize: 16),
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

class RadiologistPaymentSuccessDialog extends StatelessWidget {
  final int totalCost;
  final String radiologistName;

  RadiologistPaymentSuccessDialog(
      {required this.totalCost, required this.radiologistName});

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
            'Payment Successful',
            style: TextStyle(
              color: Const.tosca,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your payment has been successfully sent to Dr. $radiologistName.',
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
            'How was your experience?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your feedback will help us improve our\nradiology services',
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
                  return RadiologistFeedbackForm(
                    radiologistName: radiologistName,
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Const.tosca,
              minimumSize: const Size(150, 50),
            ),
            child: const Text(
              'Provide Feedback',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.go(AppRoutes.home);
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

class RadiologistFeedbackForm extends StatefulWidget {
  final String radiologistName;

  RadiologistFeedbackForm({required this.radiologistName});

  @override
  _RadiologistFeedbackFormState createState() =>
      _RadiologistFeedbackFormState();
}

class _RadiologistFeedbackFormState extends State<RadiologistFeedbackForm> {
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
                'You rated Dr. ${widget.radiologistName} $selectedStar stars',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Share your experience with the radiology service...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Give a tip to Dr. ${widget.radiologistName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTipCard('\$5'),
                _buildTipCard('\$10'),
                _buildTipCard('\$20'),
                _buildTipCard('\$50'),
                _buildTipCard('\$100'),
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
                  hintText: 'Enter tip amount',
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
                          builder: (context) => RadiologistFeedbackDetails()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Const.tosca,
                  ),
                  child: const Text(
                    'Submit Feedback',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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

class RadiologistFeedbackDetails extends StatelessWidget {
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
              'Your radiology appointment has been completed and can be viewed in the appointments history',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutes.home);
                    MyApp.showBottomAppBar(context);
                  },
                  child: const Text(
                    'View Appointments',
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
