import 'package:flutter/material.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/professional_entity.dart';
import 'package:m2health/models/provider.dart';
import 'package:m2health/views/book_appointment.dart';
import 'package:m2health/const.dart';

class ProfessionalDetailsPage extends StatelessWidget {
  final ProfessionalEntity professional;

  const ProfessionalDetailsPage({
    Key? key,
    required this.professional,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${professional.role} Details',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile header
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
                        image: professional.avatar ?? '',
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.local_hospital,
                            size: 25,
                            color: Colors.grey[600],
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
                  professional.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  professional.role,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stats row
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
                          '${professional.experience} Y++',
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
                              professional.rating.toString(),
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
            // About me
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
              professional.about ?? '',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            // Working Information
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
                Text(professional.workingHours ?? 'Not specified'),
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
                  professional.workplace ?? 'Not specified',
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Certification
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
            // Reviews
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
            // final providerData = {
            //   'id': professional.id,
            //   'name': professional.name,
            //   'avatar': professional.avatar,
            //   'role': professional.role.toLowerCase(),
            //   'provider_type': professional.providerType.toLowerCase(),
            //   'experience': professional.experience,
            //   'rating': professional.rating,
            //   'about': professional.about,
            //   'working_information': professional.workingInformation,
            //   'working_hours': professional.workingHours,
            //   'workplace': professional.workplace,
            //   'user_id': professional.userId,
            // };
            final provider = Provider(
              id: professional.id,
              name: professional.name,
              avatar: professional.avatar ?? '',
              experience: professional.experience ?? 0,
              rating: professional.rating ?? 0.0,
              about: professional.about ?? '',
              workingInformation: professional.workingInformation ?? '',
              workingHours: professional.workingHours ?? '',
              workplace: professional.workplace ?? '',
              jobTitle: professional.role,
              userId: professional.userId,
              providerType: professional.providerType,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookAppointmentPage(
                    data: BookAppointmentPageData(provider: provider)),
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
