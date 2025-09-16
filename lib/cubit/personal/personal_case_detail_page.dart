import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalCaseDetailPage extends StatelessWidget {
  final Map<String, dynamic> personalCase;

  const PersonalCaseDetailPage({super.key, required this.personalCase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          personalCase['title'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32,
            children: [
              _buildConcernCard(context),
              _buildRelatedSymptomsSection(context),
              _buildImagesSection(context),
              _buildNotes(context),

              // Related Health Record Section
              // if (relatedHealthRecord != null) ...[
              //   const SizedBox(height: 16),
              //   const Text(
              //     'Related Health Record:',
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //   ),
              //   const SizedBox(height: 8),
              //   Card(
              //     margin: const EdgeInsets.symmetric(vertical: 8.0),
              //     child: Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text('Title: ${relatedHealthRecord['title']}'),
              //           Text(
              //               'Disease Name: ${relatedHealthRecord['disease_name']}'),
              //           Text(
              //               'Disease History: ${relatedHealthRecord['disease_history']}'),
              //           Text('Symptoms: ${relatedHealthRecord['symptoms']}'),
              //           Text(
              //               'Special Consideration: ${relatedHealthRecord['special_consideration']}'),
              //           Text(
              //               'Treatment Info: ${relatedHealthRecord['treatment_info']}'),
              //           const SizedBox(height: 8),
              //           if (relatedHealthRecord['file_url'] != null)
              //             GestureDetector(
              //               onTap: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => FileViewerScreen(
              //                       url: relatedHealthRecord['file_url'],
              //                     ),
              //                   ),
              //                 );
              //               },
              //               child: Text(
              //                 'View File',
              //                 style: const TextStyle(
              //                   color: Colors.blue,
              //                   decoration: TextDecoration.underline,
              //                 ),
              //               ),
              //             ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConcernCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color(0xffeef9fe),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFBFE8FF),
          width: 2,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text(
              personalCase['title'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                const Text(
                  "Concern / Question",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text("\"${personalCase['description']}\""),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                Text(
                  "Created on: ${DateFormat('EEEE, MMM d, y').format(DateTime.parse(personalCase['created_at']))}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedSymptomsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: [
        const Text("Related Symptoms",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: <Widget>[
            _buildChip('Insomnia', const Color(0xFF65C18C)),
            _buildChip('Headache', const Color(0xFFB9A1F5)),
            _buildChip('Fatigue', const Color(0xFF5589ED)),
            _buildChip(
                'Waking up multiple times at night', const Color(0xFFE25B5B)),
            _buildChip('Feeling tired all the day', const Color(0xFFECA352)),
          ],
        )
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: BorderSide.none,
    );
  }

  Widget _buildImagesSection(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 18,
        children: [
          const Text("Images",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 images per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: personalCase['images'].length,
            itemBuilder: (context, index) {
              final imageUrl = personalCase['images'][index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ]);
  }

  Widget _buildNotes(BuildContext context) {
    final List<Map<String, dynamic>> pharmacistNotes = [
      {
        'title': 'Recommended Medication',
        'points': [
          {
            'point': 'Melatonin (3 mg)',
            'description': 'helps regulate the sleep cycle',
          },
          {
            'point': 'Diphenhydramine (OTC sleep aid)',
            'description':
                'if melatonin is not effective (short-term use only)',
          },
        ],
      },
      {
        'title': 'Lifestyle Advice',
        'points': [
          {
            'point': 'Sleep Hygiene',
            'description':
                'Go to bed and wake up at the same time every day. Avoid screens 1 hour before sleep.',
          },
          {
            'point': 'Diet & Habits',
            'description':
                'Avoid caffeine (coffee, tea, soda) after 5 PM. Reduce alcohol and smoking before bedtime.',
          },
          {
            'point': 'Relaxation',
            'description':
                'Try meditation, deep breathing, or light stretching before sleep, Use the bed only for sleeping (avoid working in bed).',
          },
        ],
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pharmacist Notes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 18),
        Column(
          children: pharmacistNotes
              .map((note) => _buildNoteCard(
                    title: note['title'],
                    points: note['points'],
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildNoteCard(
      {required String title, required List<dynamic> points}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: const Color(0xfffff4e8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xfffee9d5), // Border color
          width: 1.5,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: points.map((pointData) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ", style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pointData['point'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            if (pointData['description'].isNotEmpty)
                              Text(
                                pointData['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// class FileViewerScreen extends StatelessWidget {
//   final String url;

//   const FileViewerScreen({Key? key, required this.url}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('File Viewer'),
//       ),
//       body: Center(
//         child: Text('Display file from: $url'),
//       ),
//     );
//   }
// }
