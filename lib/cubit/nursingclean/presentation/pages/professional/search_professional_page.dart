import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/professional/professional_event.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/professional/professional_state.dart';
import 'package:m2health/cubit/nursingclean/presentation/pages/professional/professional_details_page.dart';

class SearchProfessionalPage extends StatefulWidget {
  final String serviceType;

  const SearchProfessionalPage({super.key, required this.serviceType});

  @override
  State<SearchProfessionalPage> createState() => _SearchProfessionalPageState();
}

class _SearchProfessionalPageState extends State<SearchProfessionalPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<ProfessionalBloc>()
        .add(GetProfessionalsEvent(widget.serviceType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Nurse',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Nurse',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ProfessionalBloc, ProfessionalState>(
                builder: (context, state) {
                  if (state is ProfessionalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfessionalLoaded) {
                    final professionals = state.professionals;
                    return ListView.builder(
                      itemCount: professionals.length,
                      itemBuilder: (context, index) {
                        final professional = professionals[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: Colors.grey[300],
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                professional.avatar ?? '',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Icon(
                                                    Icons.person,
                                                    size: 25,
                                                    color: Colors.grey[600],
                                                  );
                                                },
                                              )),
                                        ),
                                        const Positioned(
                                          top: -6,
                                          right: -6,
                                          child: Icon(
                                            Icons.circle,
                                            color: Color(0xFF8EF4BC),
                                            size: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        // StarRating(
                                        //     rating: professional.rating),
                                        const SizedBox(width: 4),
                                        Text(professional.rating.toString()),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        professional.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(professional.jobTitle ?? 'Nurse'),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfessionalDetailsPage(
                                                    professionalId:
                                                        professional.id,
                                                    serviceType:
                                                        widget.serviceType,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Appointment',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              professional.isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                            ),
                                            color: const Color(0xFF35C5CF),
                                            onPressed: () {
                                              context
                                                  .read<ProfessionalBloc>()
                                                  .add(
                                                    ToggleFavoriteEvent(
                                                      professional.id,
                                                      !professional.isFavorite,
                                                    ),
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ProfessionalError) {
                    return Center(
                        child: Text(
                            'Failed to load professionals: ${state.message}'));
                  } else {
                    return const Center(
                        child: Text('Failed to load professionals'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
