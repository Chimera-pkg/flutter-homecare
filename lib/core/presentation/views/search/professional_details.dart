import 'package:flutter/material.dart';
import 'package:m2health/core/data/models/provider.dart';
import 'package:m2health/core/presentation/views/book_appointment.dart';
import 'package:m2health/const.dart';

class ProfessionalProfilePage extends StatelessWidget {
  final Map<String, dynamic>
      professional; // Works for both Pharmacist and Nurse
  final String role; // Role: "Pharmacist" or "Nurse"

  const ProfessionalProfilePage({
    Key? key,
    required this.professional,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure all required fields are not null with proper type checking
    final String avatar = professional['avatar']?.toString() ?? '';
    final String name = professional['name']?.toString() ?? 'Unknown';
    final String about =
        professional['about']?.toString() ?? 'No information available';
    final String daysHour =
        professional['days_hour']?.toString() ?? 'Not specified';
    final String mapsLocation =
        professional['maps_location']?.toString() ?? 'Not specified';

    // Safe conversion for numeric values
    final int experience = _safeIntConversion(professional['experience']);
    final double rating = _safeDoubleConversion(professional['rating']);
    final int providerId = _safeIntConversion(professional['id']);
    // final int userId = _safeIntConversion(professional['user_id']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$role Details', // Dynamic title
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FadeInImage.assetNetwork(
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: 'assets/images/images_budi.png',
                        image: avatar,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/images_budi.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  role, // Dynamic role
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          '180+', // Example data
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Const.tosca,
                          ),
                        ),
                        const Text('Patients'),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          '$experience Y++',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Const.tosca,
                          ),
                        ),
                        const Text('Experience'),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              rating.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Const.tosca,
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                        const Text(
                          'Rating',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About Me',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              about,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Working Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text(daysHour),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                ),
                const SizedBox(width: 8),
                Text(
                  mapsLocation,
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Professional Certification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Column(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 112,
                        height: 76,
                        child:
                            Image.asset('assets/images/cert${index + 1}.png'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Certificate Title $index',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('ID Number: 12345$index'),
                            const Text('Issued: 2021'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle See All click
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            Column(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/review1.png'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Reviewer $index',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Text('4.5'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This is a detailed review comment that can be seen in full. '
                        'It provides insights and feedback about the professional\'s services.',
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Create complete provider data including ID and role
            // final providerData = {
            //   'id': providerId, // Include provider ID
            //   'name': name,
            //   'avatar': avatar,
            //   'role': role.toLowerCase(), // pharmacist or nurse
            //   'provider_type':
            //       role.toLowerCase(), // Ensure provider_type is included
            //   'experience': experience,
            //   'rating': rating,
            //   'about': about,
            //   'working_information': professional['working_information'] ?? '',
            //   'days_hour': daysHour,
            //   'maps_location': mapsLocation,
            //   'certification': professional['certification'] ?? '',
            //   'user_id': professional['user_id'] ?? 0,
            // };
            final providerData = Provider(
              id: providerId,
              name: name,
              avatar: avatar,
              experience: experience,
              rating: rating,
              about: about,
              workingInformation:
                  professional['working_information']?.toString() ?? '',
              workingHours: daysHour,
              workplace: mapsLocation,
              jobTitle: professional['job_title']?.toString() ?? '',
              userId: _safeIntConversion(professional['user_id']),
              providerType: role.toLowerCase(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            print(
                'Navigating to book appointment with provider data: $providerData');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookAppointmentPage(
                  data: BookAppointmentPageData(
                      provider: providerData), // Pass complete provider data
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF35C5CF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Book Appointment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

int _safeIntConversion(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _safeDoubleConversion(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
