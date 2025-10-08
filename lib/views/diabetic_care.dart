import 'package:flutter/material.dart';
import 'package:m2health/app_localzations.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/views/diabeticprofile/diabeticprofile.dart';

import 'package:m2health/widgets/chat_pharma.dart';

class DiabeticCare extends StatefulWidget {
  @override
  _PharmaState createState() => _PharmaState();
}

class PharmaCard extends StatelessWidget {
  final Map<String, String> pharma;
  final VoidCallback onTap;
  final Color color;

  const PharmaCard(
      {required this.pharma, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: 360,
        height: 260,
        padding: const EdgeInsets.all(16.0),
        color:
            color.withOpacity(0.1), // Set the background color with 10% opacity
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
                        style: const TextStyle(
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

class _PharmaState extends State<DiabeticCare> {
  final List<Map<String, String>> dummyTenders = [
    {
      'title': 'Diabetic Retinal\nPhotography (DRP)',
      'description':
          'A common eye disease among diabetic\npatients. Blood capillaries may bleed\nand damage the retina, potentially\nleading to blindness. Regular\ndiabetic retinal photography\ncan detect and monitor your eyes.',
      'imagePath': 'assets/images/ilu_diabet_retina.png',
      'color': '9AE1FF',
      'opacity': '0.33',
    },
    {
      'title': 'Diabetic Foot Screening\n (DFS)',
      'description':
          'Conducted by trained nurses, who will\nalso educate on proper footcare and\ngood sugar control. Referrals to\nfootcare specialists will be made\nwhere appropriate.',
      'imagePath': 'assets/images/ilu_diabet_foot.png',
      'color': 'B28CFF',
      'opacity': '0.2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('diabetic_care2'),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiabetesFormPage(),
                            ),
                          ).then((_) {
                            // Show the bottom navigation bar when returning
                            // navbarVisibility(false);
                          });
                          return;
                        case 1:
                          // navbarVisibility(true);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => PersonalPage(),
                          //   ),
                          // ).then((_) {
                          //   // Show the bottom navigation bar when returning
                          //   // navbarVisibility(false);
                          // });
                          return;
                        case 2:
                          route = AppRoutes.home;
                          break;
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

  PharmaDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  _PharmaDetailPageState createState() => _PharmaDetailPageState();
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
