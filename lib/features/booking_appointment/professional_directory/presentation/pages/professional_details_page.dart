import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/reviewer.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_state.dart';
import 'package:m2health/const.dart';
import 'package:m2health/service_locator.dart';

class ProfessionalDetailsPage extends StatelessWidget {
  final int professionalId;
  final String serviceType;
  final Function onButtonPressed;

  const ProfessionalDetailsPage({
    super.key,
    required this.professionalId,
    required this.serviceType,
    required this.onButtonPressed,
  });

  String get title {
    switch (serviceType) {
      case 'nursing':
        return 'Nurse Details';
      case 'pharmacist':
        return 'Pharmacist Details';
      case 'radiologist':
        return 'Radiologist Details';
      default:
        return 'Professional Details';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfessionalDetailCubit(getProfessionalDetail: sl())
        ..fetchProfessionalDetail(serviceType, professionalId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<ProfessionalDetailCubit, ProfessionalDetailState>(
          builder: (context, state) {
            if (state is ProfessionalDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfessionalDetailError) {
              return Center(child: Text(state.message));
            } else if (state is ProfessionalDetailLoaded) {
              final professional = state.professional;
              return _buildProfessionalBody(context, professional);
            }
            return const Center(child: Text('Failed to load details.'));
          },
        ),
        bottomNavigationBar:
            BlocBuilder<ProfessionalDetailCubit, ProfessionalDetailState>(
          builder: (context, state) {
            if (state is ProfessionalDetailLoaded) {
              return _buildBottomButton(context, state.professional);
            }
            return _buildBottomButton(context, null, disabled: true);
          },
        ),
      ),
    );
  }

  Widget _buildProfessionalBody(
      BuildContext context, ProfessionalEntity professional) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileHeader(professional),
          const SizedBox(height: 16),
          _buildStatsRow(professional),
          const SizedBox(height: 32),
          _buildAboutMe(professional),
          const SizedBox(height: 32),
          _buildWorkingInfo(professional),
          const SizedBox(height: 32),
          _buildCertificates(professional),
          const SizedBox(height: 32),
          _buildReviews(professional.reviews ?? []),
          const SizedBox(height: 80), // Padding for bottom nav bar
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfessionalEntity professional) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
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
                    Icons.person,
                    size: 25,
                    color: Colors.grey[600],
                  );
                },
              ),
            ),
            const Positioned(
              top: -8,
              right: -8,
              child: Icon(
                Icons.circle,
                color: Color(0xFF8EF4BC),
                size: 16,
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
          professional.jobTitle ?? 'Nurse',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ProfessionalEntity professional) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Expanded(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(8.0),
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
                  Text('Patients'),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    '${professional.experience} Y+',
                    style: const TextStyle(
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
        ),
        Expanded(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFEEB854),
                      ),
                      Text(
                        professional.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Const.tosca,
                        ),
                      ),
                    ],
                  ),
                  const Text('Rating'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutMe(ProfessionalEntity professional) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Me',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          professional.about ?? 'No description available.',
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildWorkingInfo(ProfessionalEntity professional) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Working Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.calendar_today, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(professional.workingHours ?? 'Not specified'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                professional.workplace ?? 'Not specified',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCertificates(ProfessionalEntity professional) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Professional Certificate',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        if (professional.certificates == null ||
            professional.certificates!.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('No certificate available.'),
          )
        else
          Column(
            children: professional.certificates!.map((cert) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 112,
                      height: 76,
                      child: Image.network(
                        cert.fileURL,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // TODO: Replace with actual placeholder image
                          return Image.asset('assets/images/cert1.png');
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('ID Number: ${cert.registrationNumber}'),
                          Text('Issued: ${cert.issuedOn}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildReviews(List<ReviewEntity> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            if (reviews.isNotEmpty)
              TextButton(
                onPressed: () {
                  // Handle See All click
                },
                child: const Text('See All'),
              ),
          ],
        ),
        if (reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('No reviews available yet.'),
          )
        else
          Column(
            children: reviews.map((review) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: review.reviewer.avatar.isNotEmpty
                              ? NetworkImage(review.reviewer.avatar)
                              : const AssetImage('assets/images/review1.png')
                                  as ImageProvider,
                          onBackgroundImageError: (exception, stackTrace) {},
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            review.reviewer.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow),
                            Text(review.score.toString()),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.description.isNotEmpty
                          ? review.description
                          : 'No comment provided.',
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildBottomButton(
      BuildContext context, ProfessionalEntity? professional,
      {bool disabled = false}) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: ElevatedButton(
        onPressed: (disabled || professional == null)
            ? null
            : () {
                onButtonPressed();

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => BookAppointmentPage(
                //       professional: professional,
                //     ),
                //   ),
                // );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF35C5CF),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Schedule Appointment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
