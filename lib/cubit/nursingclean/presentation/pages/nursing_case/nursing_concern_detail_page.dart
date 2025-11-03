import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_issue.dart';

class NursingConcernDetailPage extends StatelessWidget {
  final NursingIssue issue;

  const NursingConcernDetailPage({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          issue.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConcernCard(context),
              const SizedBox(height: 32),
              // _buildRelatedSymptomsSection(context),
              // const SizedBox(height: 32),
              _buildImagesSection(context),
              const SizedBox(height: 32),
              // _buildNotes(context),
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
          children: [
            Text(
              issue.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Concern / Question",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text("\"${issue.description}\""),
              ],
            ),
            const SizedBox(height: 12),
            if (issue.updatedAt != null)
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    "Created on: ${DateFormat('EEEE, MMM d, y').format(issue.updatedAt!)}",
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
    // Dummy Data
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Related Symptoms",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: <Widget>[
            _buildChip('Swollen and red', const Color(0xFFE25B5B)),
            _buildChip('Limited Mobility', const Color(0xFFB9A1F5)),
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
    final allImages = [...issue.imageUrls, ...issue.images];

    if (allImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Images",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      const SizedBox(height: 18),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 images per row
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: allImages.length,
        itemBuilder: (context, index) {
          final imageItem = allImages[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: imageItem is String
                ? Image.network(
                    imageItem, // Remote image URL
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error));
                    },
                  )
                : Image.file(
                    imageItem as File, // Local image File
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error));
                    },
                  ),
          );
        },
      ),
    ]);
  }

  Widget _buildNotes(BuildContext context) {
    // Dummy Data
    final List<Map<String, dynamic>> nurseNotes = [
      {
        'title': 'Recommended Medication',
        'points': [
          {
            'point': 'Melatonin (3 mg)',
            'description': 'helps regulate the sleep cycle',
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
        ],
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nurse Notes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 18),
        Column(
          children: nurseNotes
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
