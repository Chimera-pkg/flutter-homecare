// import 'package:flutter/material.dart';

// class MobilityStatusRadioList extends StatefulWidget {
//   final String? mobilityStatus;
//   final ValueChanged<String?> onChanged;

//   MobilityStatusRadioList(
//       {required this.mobilityStatus, required this.onChanged});

//   @override
//   _MobilityStatusRadioListState createState() =>
//       _MobilityStatusRadioListState();
// }

// class _MobilityStatusRadioListState extends State<MobilityStatusRadioList> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         RadioListTile<String>(
//           title: const Text('Bedbound'),
//           value: 'bedbound',
//           groupValue: widget.mobilityStatus,
//           onChanged: widget.onChanged,
//           activeColor: Color(0xFF35C5CF),
//         ),
//         RadioListTile<String>(
//           title: const Text('Wheelchair bound'),
//           value: 'wheelchair bound',
//           groupValue: widget.mobilityStatus,
//           onChanged: widget.onChanged,
//           activeColor: Color(0xFF35C5CF),
//         ),
//         RadioListTile<String>(
//           title: const Text('Ambulatory'),
//           value: 'ambulatory',
//           groupValue: widget.mobilityStatus,
//           onChanged: widget.onChanged,
//           activeColor: Color(0xFF35C5CF),
//         ),
//         RadioListTile<String>(
//           title: const Text('Independent'),
//           value: 'independent',
//           groupValue: widget.mobilityStatus,
//           onChanged: widget.onChanged,
//           activeColor: Color(0xFF35C5CF),
//         ),
//       ],
//     );
//   }
// }
