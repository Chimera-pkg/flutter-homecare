import 'package:flutter/material.dart';
import 'package:m2health/app_localzations.dart';
import 'package:m2health/features/personal/personal_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/core/presentation/views/health_coaching.dart';

import 'package:m2health/core/presentation/widgets/chat_pharma.dart';

class PharmaServices extends StatefulWidget {
  const PharmaServices({super.key});

  @override
  _PharmaState createState() => _PharmaState();
}

class PharmaCard extends StatelessWidget {
  final Map<String, String> pharma;
  final VoidCallback onTap;
  final Color color;

  const PharmaCard(
      {super.key,
      required this.pharma,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: 357,
        height: 243,
        padding: const EdgeInsets.all(16.0),
        color: color.withValues(
            alpha: 0.1), // Set the background color with 10% opacity
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pharma['title']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${pharma['description']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400, // Light font weight
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 5),
                      const Text(
                        'Book Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF35C5CF),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image.asset(
                        'assets/icons/ic_play.png',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: -25,
              right: -20,
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0), // Adjust the padding as needed
                  child: Image.asset(
                    pharma['imagePath']!,
                    width: 185,
                    height: 139,
                    fit: BoxFit.contain,
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

class _PharmaState extends State<PharmaServices> {
  final List<Map<String, String>> dummyTenders = [
    {
      'title': 'Medication Counseling\nand Education',
      'description':
          'Medication counseling and education guide\npatients on proper use, side effects, and\nadherence to prescriptions,\nenhancing safety and\nimproving health outcomes.',
      'imagePath': 'assets/icons/ilu_pharmacist.png',
      'color': 'F79E1B',
      'opacity': '0.1',
    },
    {
      'title': 'Comprehensive Therapy\nReview',
      'description':
          'Comprehensive review of your medication\nand lifestyle to optimize treatment\noutcomes and minimize potential side\neffects',
      'imagePath': 'assets/icons/ilu_therapy.png',
      'color': 'B28CFF',
      'opacity': '0.2',
    },
    {
      'title': 'Health Coaching',
      'description':
          'Personalized guidance and support to help\nindividuals achieve their health goals, manage\nchronic conditions, and improve overall well-\nbeing, with specialized programs for weight\nmanagement, diabetes management, high\nblood pressure management, and high\ncholesterol management',
      'imagePath': 'assets/icons/ilu_coach.png',
      'color': '9AE1FF',
      'opacity': '0.33',
    },
    {
      'title': 'Smoking Cessation',
      'description':
          'Smoking cessation involves quitting\nsmoking through strategies like\ncounseling, medications, and support\nprograms to improve health and\nreduce the risk of smoking-related\ndiseases.',
      'imagePath': 'assets/icons/ilu_lung.png',
      'color': 'FF9A9A',
      'opacity': '0.19',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.translate('pharmacist_services2'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: dummyTenders.length,
                itemBuilder: (context, index) {
                  final tender = dummyTenders[index];
                  return PharmaCard(
                    pharma: tender,
                    onTap: () {
                      String route;
                      switch (index) {
                        case 0:
                          // navbarVisibility(true);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonalPage(
                                title: "Pharmacist Services Case",
                                serviceType: "Pharmacist",
                                onItemTap: (item) {
                                  // Handle item tap
                                },
                              ),
                            ),
                          );
                          return;
                        case 1:
                          // navbarVisibility(true);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonalPage(
                                title: "Pharmacist Services Case",
                                serviceType: "Pharmacist",
                                onItemTap: (item) {
                                  // Handle item tap
                                },
                              ),
                            ),
                          );
                          return;
                        case 2:
                          // navbarVisibility(true);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HealthCoaching(),
                            ),
                          ).then((_) {
                            // Show the bottom navigation bar when returning
                            // navbarVisibility(false);
                          });
                          return;
                        case 3:
                          route = AppRoutes.home;
                          break;
                        default:
                          route = AppRoutes.home;
                      }
                      Navigator.pushNamed(context, route);
                    },
                    color: Color(int.parse('0xFF${tender['color']}'))
                        .withOpacity(tender['opacity'] != null
                            ? double.parse(tender['opacity']!)
                            : 1.0),
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PharmaDetailPage extends StatefulWidget {
  final Map<String, String> item;

  const PharmaDetailPage({super.key, required this.item});

  @override
  State<PharmaDetailPage> createState() => _PharmaDetailPageState();
}

class _PharmaDetailPageState extends State<PharmaDetailPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _chatHistory = [];

  // void _shareProduct() {
  //   final String productUrl = Const.URL_WEB + '/tender/detail/${item['title']}';
  //   Share.share(productUrl, subject: '');
  // }

  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      setState(() {
        _chatHistory.add({
          "message": _chatController.text,
          "isSender": true,
        });
        _chatController.clear();
      });

      // Simulate a response from the other side
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _chatHistory.add({
            "message": "This is a dummy response",
            "isSender": false,
          });
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatPharma(
      chatHistory: _chatHistory,
      chatController: _chatController,
      scrollController: _scrollController,
      sendMessage: _sendMessage,
    );
  }
}
