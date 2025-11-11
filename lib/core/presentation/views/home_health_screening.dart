import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/app_localzations.dart';
import 'package:m2health/const.dart';

import 'package:m2health/route/app_routes.dart';
import 'package:m2health/core/presentation/views/medical_store.dart';

import 'package:m2health/core/presentation/widgets/chat_pharma.dart';

class HomeHealth extends StatefulWidget {
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

class _PharmaState extends State<HomeHealth> {
  final List<Map<String, String>> dummyTenders = [
    {
      'title': 'At-home diagnostic tests',
      'description':
          'Patients collect samples at home using a self-\ncollection kit, which includes materials like swabs\n, test cards, and collection tubes, and submit them\nto a CLIA/CAP certified lab (telemedicine lab) for\nprocessing. Laboratory technicians process these samples and upload results to an online portal.\nPrimary care doctors, specialists, or other\nhealthcare professionals review results and walk patients through next steps.',
      'imagePath': 'assets/images/ilu_diagnostic.png',
      'color': '9AE1FF',
      'opacity': '0.33',
    },
    {
      'title': 'Point-of-care tests',
      'description':
          'Diagnostics done outside of a lab that patients\ncan take by themselves at home. These tests\ndevelop rapidly and produce results without a\ndoctor or lab technician present. With point-of-\ncare tests, patients review results outside a\nmedical setting and determine their own next\nsteps.',
      'imagePath': 'assets/images/ilu_pointofcare.png',
      'color': 'B28CFF',
      'opacity': '0.2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('home_health'),
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
                              builder: (context) => HomeHealthScreeningDetail(),
                            ),
                          ).then((_) {
                            // Show the bottom navigation bar when returning
                            // navbarVisibility(false);
                          });
                          return;
                        case 1:
                          GoRouter.of(context).go(AppRoutes.medicalStore);
                          return;
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

class HomeHealthScreeningDetail extends StatefulWidget {
  @override
  _HomeHealthScreeningDetailState createState() =>
      _HomeHealthScreeningDetailState();
}

class _HomeHealthScreeningDetailState extends State<HomeHealthScreeningDetail> {
  bool kidneyFunctionChecked = false;
  bool urinalysisChecked = false;
  bool liverProfileChecked = false;
  bool ovarianScreeningChecked = false;
  bool prostateScreeningChecked = false;
  bool nasopharyngealCancerScreeningChecked = false;
  bool pancreaticScreeningChecked = false;
  bool breastScreeningChecked = false;
  bool betaHCGChecked = false;
  bool cReactiveProteinChecked = false;
  bool cardiacProfileTestChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Health Screening'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Screening',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(color: Colors.grey),
            _buildScreeningCard(
              'Kidney Function',
              kidneyFunctionChecked,
              (value) {
                setState(() {
                  kidneyFunctionChecked = value!;
                });
              },
            ),
            _buildScreeningCard(
              'Urinalysis',
              urinalysisChecked,
              (value) {
                setState(() {
                  urinalysisChecked = value!;
                });
              },
            ),
            _buildScreeningCard(
              'Liver Profile',
              liverProfileChecked,
              (value) {
                setState(() {
                  liverProfileChecked = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Cancer Biomarker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(color: Colors.grey),
            _buildScreeningCard(
              'Ovarian Screening(CA 125)',
              ovarianScreeningChecked,
              (value) {
                setState(() {
                  ovarianScreeningChecked = value!;
                });
              },
            ),
            _buildScreeningCard(
              'Prostate Screening(PSA)',
              prostateScreeningChecked,
              (value) {
                setState(() {
                  prostateScreeningChecked = value!;
                });
              },
            ),
            _buildScreeningCard(
              'Nasopharyngeal Cancer Screening(EBV)',
              nasopharyngealCancerScreeningChecked,
              (value) {
                setState(() {
                  nasopharyngealCancerScreeningChecked = value!;
                });
              },
            ),
            _buildScreeningCard(
              'Pancreatic Screening(EBV)',
              pancreaticScreeningChecked,
              (value) {
                setState(() {
                  pancreaticScreeningChecked = value!;
                });
              },
            ),
            _buildScreeningCard(
              'Breast Screening (CA 15.3)',
              breastScreeningChecked,
              (value) {
                setState(() {
                  breastScreeningChecked = value!;
                });
              },
            ),
            _buildScreeningCard(
              'Beta HCG (Testes)',
              betaHCGChecked,
              (value) {
                setState(() {
                  betaHCGChecked = value!;
                });
              },
            ),
            const Text(
              'Cardiovascular Screening',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(color: Colors.grey),
            _buildScreeningCard(
              'C-Reactive Protein (CRP)',
              cReactiveProteinChecked,
              (value) {
                setState(() {
                  cReactiveProteinChecked = value!;
                });
              },
            ),
            _buildScreeningCard(
              'Cardiac Profile Test(AA1 + APB)',
              cardiacProfileTestChecked,
              (value) {
                setState(() {
                  cardiacProfileTestChecked = value!;
                });
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated Budget',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.info_outline_rounded, color: Colors.grey),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '\$145',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 352,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const ComingSoonDialog(),
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreeningCard(
      String title, bool isChecked, ValueChanged<bool?> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: Const.tosca,
        ),
        title: Text(title),
        trailing: const Icon(Icons.info_outline, color: Colors.grey),
      ),
    );
  }
}
