// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:m2health/cubit/personal/personal_cubit.dart';
// import 'dart:io';
// import 'add_concern_page.dart';
// import 'add_issue_page.dart';

// class AddSummaryPage extends StatelessWidget {
//   final String issueTitle;
//   final String description;
//   final List<File> images;

//   AddSummaryPage({
//     required this.issueTitle,
//     required this.description,
//     required this.images,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Summary',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Tell us your concern',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Issue Title: $issueTitle',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Description: $description',
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: images.map((image) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 10.0),
//                   child: Container(
//                     width: 100,
//                     height: 100,
//                     color: Colors.grey.shade200,
//                     child: Image.file(image, fit: BoxFit.cover),
//                   ),
//                 );
//               }).toList(),
//             ),
//             const Spacer(),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: 352,
//                   height: 58,
//                   child: OutlinedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddConcernPage(),
//                         ),
//                       );
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Color(0xFF35C5CF)),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     child: const Text(
//                       'Add an Issue',
//                       style: TextStyle(color: Color(0xFF35C5CF), fontSize: 20),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: 352,
//                   height: 58,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BlocProvider.value(
//                             value: context.read<PersonalCubit>(),
//                             child: AddIssuePage(
//                               issue:
//                                   issueTitle, // Replace with a defined variable
//                               serviceType: "Pharmacist", // Pass serviceType
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF35C5CF),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     child: const Text(
//                       'Next',
//                       style: const TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
