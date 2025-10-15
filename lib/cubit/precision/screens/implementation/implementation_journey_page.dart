import 'package:flutter/material.dart';
import 'package:m2health/cubit/precision/widgets/precision_widgets.dart';

class ImplementationJourneyPage extends StatelessWidget {
  const ImplementationJourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Implementation Journey'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FeatureDetailCard(
                      iconData: Icons.description_outlined,
                      title: 'In-Depth Assesment (2-4 weeks)',
                      sections: {
                        // Using null key for single section without header
                        null: [
                          'Omics testing + functional medicine examinations',
                          'Digital lifestyle profiling',
                        ],
                      },
                    ),
                    FeatureDetailCard(
                      iconData: Icons.groups_outlined,
                      title: 'Intervention (3-6 months)',
                      sections: {
                        null: [
                          'Monthly biomarker retesting',
                          'Dynamic microbiome adjustment',
                          'Digital therapy app support',
                        ],
                      },
                    ),
                    FeatureDetailCard(
                      iconData: Icons.bar_chart_outlined,
                      title: 'Maintenance',
                      sections: {
                        null: [
                          'Annual genomic re-evaluation',
                          'Adaptive nutrition strategies for environmental/lifestyle changes',
                        ],
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(text: 'Book Now', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
