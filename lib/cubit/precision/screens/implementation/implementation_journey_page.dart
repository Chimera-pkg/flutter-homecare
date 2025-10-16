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
                  spacing: 16,
                  children: [
                    FeatureDetailCard(
                      iconData: Icons.description_outlined,
                      title: 'In-Depth Assesment (2-4 weeks)',
                      child: Column(
                        children: [
                          CardBulletPoint(
                              text:
                                  'Omics testing + functional medicine examinations'),
                          CardBulletPoint(text: 'Digital lifestyle profiling'),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.groups_outlined,
                      title: 'Intervention (3-6 months)',
                      child: Column(
                        children: [
                          CardBulletPoint(text: 'Monthly biomarker retesting'),
                          CardBulletPoint(
                              text: 'Dynamic microbiome adjustment'),
                          CardBulletPoint(text: 'Digital therapy app support'),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.bar_chart_outlined,
                      title: 'Maintenance',
                      child: Column(
                        children: [
                          CardBulletPoint(text: 'Annual genomic re-evaluation'),
                          CardBulletPoint(
                              text:
                                  'Adaptive nutrition strategies for environmental/lifestyle changes'),
                        ],
                      ),
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
