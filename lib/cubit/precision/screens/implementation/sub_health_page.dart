import 'package:flutter/material.dart';
import 'package:m2health/cubit/precision/widgets/precision_widgets.dart';

class SubHealthPage extends StatelessWidget {
  const SubHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sub-Health Populations'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FeatureDetailCard(
                      iconData: Icons.thermostat,
                      title: 'Metabolic Function Optimization',
                      borderColor: Color(0xFFF79E1B),
                      sections: {
                        'APPLICABLE ISSUES': [
                          'Fatigue syndrome',
                          'Blood glucose fluctuations',
                          'Mild insulin resistance',
                        ],
                        'SERVICES INCLUDE': [
                          'CGM-guided card tolerance assesment',
                          'Mitochondrial support (CoQ10, alpha-lipoic acid)',
                        ],
                      },
                    ),
                    FeatureDetailCard(
                      iconData: Icons.psychology,
                      title: 'Gut-Brain Axis Regulation',
                      borderColor: Color(0xFFB393FF),
                      sections: {
                        'APPLICABLE ISSUES': [
                          'Anxiety / Depression tendencies',
                          'Irritable Bowel Syndrome (IBS)',
                        ],
                        'INTERVENTIONS INCLUDE': [
                          'Gut microbiota testing (16s rRNA)',
                          'Strain-specific probiotics (e.g. PS128)',
                          'Personalized low-FODMAP diet',
                        ],
                      },
                    ),
                    FeatureDetailCard(
                      iconData: Icons.shield_outlined,
                      title: 'Immune Balance Intervention',
                      borderColor: Color(0xFF10B981),
                      sections: {
                        'APPLICABLE ISSUES': [
                          'Recurrent infections',
                          'Chronic inflammation',
                        ],
                        'SOLUTIONS INCLUDE': [
                          'VDR gene testing + vitamin D dosing',
                          'Flavonoid supplementation (based on COMT genotype)',
                          'AIDI (Anti-inflammatory Diet Index) improvement',
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
