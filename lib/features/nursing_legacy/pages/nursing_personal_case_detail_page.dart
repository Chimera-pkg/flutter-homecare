// import 'package:flutter/material.dart';
// import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';

// class NursingPersonalCaseDetailPage extends StatelessWidget {
//   final NursingCase nursingCase;

//   const NursingPersonalCaseDetailPage({Key? key, required this.nursingCase})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(nursingCase.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Description:',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 8),
//             Text(nursingCase.description),
//             const SizedBox(height: 16),
//             Text(
//               'Images:',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 8),
//             if (nursingCase.images.isNotEmpty)
//               Expanded(
//                 child: GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                   ),
//                   itemCount: nursingCase.images.length,
//                   itemBuilder: (context, index) {
//                     return Image.file(
//                       nursingCase.images[index],
//                       fit: BoxFit.cover,
//                     );
//                   },
//                 ),
//               )
//             else
//               const Text('No images attached.'),
//           ],
//         ),
//       ),
//     );
//   }
// }
