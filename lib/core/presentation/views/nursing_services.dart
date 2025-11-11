// import 'package:flutter/material.dart';
// import 'package:m2health/app_localzations.dart';
// import 'package:m2health/cubit/personal/personal_page.dart';
// import 'package:m2health/route/app_routes.dart';
// import 'package:m2health/main.dart';

// class NursingService extends StatefulWidget {
//   @override
//   _NursingState createState() => _NursingState();
// }

// class NursingCard extends StatelessWidget {
//   final Map<String, String> pharma;
//   final VoidCallback onTap;
//   final Color color;

//   const NursingCard(
//       {required this.pharma, required this.onTap, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       child: Container(
//         width: 357,
//         height: 243,
//         padding: const EdgeInsets.all(16.0),
//         color:
//             color.withOpacity(0.1), // Set the background color with 10% opacity
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${pharma['title']}',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   '${pharma['description']}',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400, // Light font weight
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextButton(
//                   onPressed: onTap,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(width: 5),
//                       Text(
//                         'Book Now',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Color(0xFF35C5CF),
//                         ),
//                       ),
//                       SizedBox(width: 5),
//                       Image.asset(
//                         'assets/icons/ic_play.png',
//                         width: 20,
//                         height: 20,
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             Positioned(
//               bottom: -25,
//               right: -20,
//               child: ClipRect(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 10.0), // Adjust the padding as needed
//                   child: Image.asset(
//                     pharma['imagePath']!,
//                     width: 185,
//                     height: 139,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _NursingState extends State<NursingService> {
//   final List<Map<String, String>> dummyTenders = [
//     {
//       'title': 'Primary Nursing',
//       'description':
//           'Monitor and administer\nnursing procedures from\nbody checking, Medication,\ntube feed and suctioning to\ninjections and wound care.',
//       'imagePath': 'assets/icons/ilu_nurse.png',
//       'color': '9AE1FF',
//       'opacity': '0.3',
//     },
//     {
//       'title': 'Specialized Nursing Services',
//       'description':
//           'Focus on recovery and leave\nthe complex nursing care in\nthe hands of our experienced\nnurse Care Pros',
//       'imagePath': 'assets/icons/ilu_nurse_special.png',
//       'color': 'B28CFF',
//       'opacity': '0.2',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.translate('nursing'),
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//       ),
//       body: Container(
//         margin: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ListView.separated(
//                 itemCount: dummyTenders.length,
//                 itemBuilder: (context, index) {
//                   final tender = dummyTenders[index];
//                   return NursingCard(
//                     pharma: tender,
//                     onTap: () {
//                       String route;
//                       switch (index) {
//                         case 0:
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PersonalPage(
//                                 title: "Nurse Services Case",
//                                 serviceType: "Nurse",
//                                 onItemTap: (item) {
//                                   // Handle item tap
//                                 },
//                               ),
//                             ),
//                           );
//                           return;
//                         case 1:
//                           // navbarVisibility(true);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => NursingService(
//                                   // item: tender,
//                                   ),
//                             ),
//                           ).then((_) {
//                             // Show the bottom navigation bar when returning
//                             // navbarVisibility(false);
//                           });
//                           return;
//                         default:
//                           route = AppRoutes.home;
//                       }
//                       Navigator.pushNamed(context, route);
//                     },
//                     color: Color(int.parse('0xFF${tender['color']}'))
//                         .withOpacity(tender['opacity'] != null
//                             ? double.parse(tender['opacity']!)
//                             : 1.0),
//                   );
//                 },
//                 separatorBuilder: (context, index) => Divider(height: 1),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
