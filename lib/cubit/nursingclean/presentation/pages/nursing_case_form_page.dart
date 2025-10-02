// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_bloc.dart';
// import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_event.dart';
// import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_state.dart';
// import 'package:m2health/cubit/nursingclean/presentation/widgets/nursing_case_form.dart';
// import 'package:m2health/widgets/add_concern_page.dart'; // Asumsi ini akan diadaptasi menjadi nursing
// import 'package:m2health/const.dart';

// class NursingCaseFormPage extends StatefulWidget {
//   const NursingCaseFormPage({super.key});

//   @override
//   State<NursingCaseFormPage> createState() => _NursingCaseFormPageState();
// }

// class _NursingCaseFormPageState extends State<NursingCaseFormPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<NursingCaseBloc>().add(GetNursingCasesEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Nurse Services Case",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const SizedBox(height: 0.0),
//             const Column(
//               children: [
//                 Center(
//                   child: Text(
//                     'Tell Us Your Concern',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF35C5CF),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//             Expanded(
//               child: BlocBuilder<NursingCaseBloc, NursingCaseState>(
//                 builder: (context, state) {
//                   if (state is NursingCaseLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is NursingCaseLoaded) {
//                     final issues = state.nursingCases;
//                     return RefreshIndicator(
//                       onRefresh: () async {
//                         context
//                             .read<NursingCaseBloc>()
//                             .add(GetNursingCasesEvent());
//                       },
//                       child: issues.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 'There are no issues added yet.\n Please add one or more issues so\nyou can proceed to the next step.',
//                                 style: TextStyle(fontSize: 16),
//                                 textAlign: TextAlign.center,
//                               ),
//                             )
//                           : ListView.builder(
//                               itemCount: issues.length,
//                               itemBuilder: (context, index) {
//                                 final issue = issues[index];
//                                 // Anda perlu menambahkan `createdAt` pada entity `NursingCase` jika ingin menggunakan tanggal
//                                 // final formattedDate = DateFormat('EEEE, MMM d, yyyy').format(issue.createdAt);

//                                 return Card(
//                                   margin:
//                                       const EdgeInsets.symmetric(vertical: 8.0),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               issue.title,
//                                               style: const TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             IconButton(
//                                               icon: const Icon(Icons.delete,
//                                                   color: Colors.red),
//                                               onPressed: () {
//                                                 // Tambahkan event delete jika diperlukan
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Text(issue.description),
//                                         const SizedBox(height: 8),
//                                         // Text(
//                                         //   'Created on: $formattedDate',
//                                         //   style: const TextStyle(color: Colors.grey),
//                                         // ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                     );
//                   } else {
//                     return const Center(child: Text('Failed to load issues'));
//                   }
//                 },
//               ),
//             ),
//             BlocBuilder<NursingCaseBloc, NursingCaseState>(
//               builder: (context, state) {
//                 final bool hasIssues =
//                     state is NursingCaseLoaded && state.nursingCases.isNotEmpty;
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 352,
//                       height: 58,
//                       child: OutlinedButton(
//                         onPressed: () {
//                           // Ganti dengan halaman form nursing yang baru
//                           showAddConcernPage(context);
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Color(0xFF35C5CF)),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         child: const Text(
//                           'Add an Issue',
//                           style:
//                               TextStyle(color: Color(0xFF35C5CF), fontSize: 20),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       width: 352,
//                       height: 58,
//                       child: ElevatedButton(
//                         onPressed: hasIssues
//                             ? () {
//                                 showAddConcernPage(context);
//                               }
//                             : null,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               hasIssues ? Const.tosca : const Color(0xFFB2B9C4),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         child: const Text(
//                           'Next',
//                           style: TextStyle(color: Colors.white, fontSize: 20),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
