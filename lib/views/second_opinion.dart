import 'package:flutter/material.dart';
import 'package:m2health/app_localzations.dart';
import 'package:m2health/features/personal/personal_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/main.dart';
import 'package:m2health/views/medical_store.dart';
import 'package:m2health/views/teleradiology.dart';

import 'package:m2health/widgets/chat_pharma.dart';

class OpinionMedical extends StatefulWidget {
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
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: 357,
        height: 280,
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
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${pharma['description']}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400, // Light font weight
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 5),
                      Text(
                        'Book Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF35C5CF),
                        ),
                      ),
                      SizedBox(width: 5),
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

class _PharmaState extends State<OpinionMedical> {
  final List<Map<String, String>> dummyTenders = [
    {
      'title': 'Teleradiology',
      'description':
          'Discover expert second opinions on medical imaging from our specialized radiologists, guiding your healthcare decisions with focused knowledge in cardiovascular, musculoskeletal, head & neck, and neuro-imaging',
      'imagePath': 'assets/images/ilu_teleradiology.png',
      'color': '9AE1FF',
      'opacity': '0.33',
    },
    {
      'title': 'Telepathology',
      'description':
          'Our specialists leverage cutting-edge telemedicine tech for remote pathology image reviews and consultations with medical teams globally',
      'imagePath': 'assets/images/ilu_telepathology.png',
      'color': 'B28CFF',
      'opacity': '0.2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('teleradiology'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
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
                              builder: (context) => TeleradiologyDetail(),
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
                          //     builder: (context) => MedicalStorePage(),
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
                separatorBuilder: (context, index) => Divider(height: 1),
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
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _chatHistory.add({
            "message": "This is a dummy response",
            "isSender": false,
          });
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
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
