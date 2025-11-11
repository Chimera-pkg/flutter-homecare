import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/app_localzations.dart';
import 'package:m2health/features/nursingclean/const.dart';
import 'package:m2health/features/nursingclean/presentation/bloc/nursing_case/nursing_case_bloc.dart';
import 'package:m2health/features/nursingclean/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/features/nursingclean/presentation/pages/nursing_case/nursing_concerns_page.dart';
import 'package:m2health/route/app_routes.dart';

class NursingService extends StatefulWidget {
  const NursingService({super.key});
  @override
  State<NursingService> createState() => _NursingState();
}

class NursingCard extends StatelessWidget {
  final Map<String, String> pharma;
  final VoidCallback onTap;
  final Color color;

  const NursingCard(
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
        color: color, // Set the background color with 10% opacity
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

class _NursingState extends State<NursingService> {
  final List<Map<String, String>> dummyTenders = [
    {
      'title': 'Primary Nursing',
      'description':
          'Monitor and administer\nnursing procedures from\nbody checking, Medication,\ntube feed and suctioning to\ninjections and wound care.',
      'imagePath': 'assets/icons/ilu_nurse.png',
      'color': '9AE1FF',
      'opacity': '0.3',
    },
    {
      'title': 'Specialized Nursing Services',
      'description':
          'Focus on recovery and leave\nthe complex nursing care in\nthe hands of our experienced\nnurse Care Pros',
      'imagePath': 'assets/icons/ilu_nurse_special.png',
      'color': 'B28CFF',
      'opacity': '0.2',
    },
  ];

  void _navigateToType(NurseServiceType serviceType) {
    context.read<NursingCaseBloc>().add(SelectServiceTypeEvent(serviceType));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NursingConcernsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('nursing'),
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
                  return NursingCard(
                    pharma: tender,
                    onTap: () {
                      switch (index) {
                        case 0:
                          _navigateToType(NurseServiceType.primaryNurse);
                          break;
                        case 1:
                          _navigateToType(NurseServiceType.specializedNurse);
                          break;
                        default:
                          Navigator.pushNamed(context, AppRoutes.home);
                      }
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
