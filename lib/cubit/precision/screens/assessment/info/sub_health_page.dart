import 'package:flutter/material.dart';
import 'package:m2health/cubit/precision/screens/assessment/forms/health_history_screen.dart';
import 'package:m2health/cubit/precision/widgets/precision_widgets.dart';

class SubHealthPage extends StatelessWidget {
  const SubHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFF79E1B);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sub-Health Populations'),
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
                      iconData: Icons.thermostat,
                      title: 'Metabolic Function Optimization',
                      color: color,
                      child: Column(
                        children: [
                          CardSection(
                            title: 'APPLICABLE ISSUES',
                            items: [
                              'Fatigue syndrome',
                              'Blood glucose fluctuations',
                              'Mild insulin resistance',
                            ],
                          ),
                          CardSection(
                            title: 'SERVICES INCLUDE',
                            items: [
                              'CGM-guided card tolerance assesment',
                              'Mitochondrial support (CoQ10, alpha-lipoic acid)',
                            ],
                          ),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.psychology,
                      title: 'Gut-Brain Axis Regulation',
                      color: color,
                      child: Column(
                        children: [
                          CardSection(
                            title: 'APPLICABLE ISSUES',
                            items: [
                              'Anxiety / Depression tendencies',
                              'Irritable Bowel Syndrome (IBS)',
                            ],
                          ),
                          CardSection(
                            title: 'INTERVENTIONS INCLUDE',
                            items: [
                              'Gut microbiota testing (16s rRNA)',
                              'Strain-specific probiotics (e.g. PS128)',
                              'Personalized low-FODMAP diet',
                            ],
                          ),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.shield_outlined,
                      title: 'Immune Balance Intervention',
                      color: color,
                      child: Column(
                        children: [
                          CardSection(
                            title: 'APPLICABLE ISSUES',
                            items: [
                              'Recurrent infections',
                              'Chronic inflammation',
                            ],
                          ),
                          CardSection(
                            title: 'SOLUTIONS INCLUDE',
                            items: [
                              'VDR gene testing + vitamin D dosing',
                              'Flavonoid supplementation (based on COMT genotype)',
                              'AIDI (Anti-inflammatory Diet Index) improvement',
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Next',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HealthHistoryScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
