import 'package:flutter/material.dart';
import 'package:m2health/features/precision/screens/assessment/forms/health_history_screen.dart';
import 'package:m2health/features/precision/widgets/precision_widgets.dart';

class ChronicDiseaseSupportPage extends StatelessWidget {
  const ChronicDiseaseSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF92A3FD);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Chronic-Disease Support'),
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
                      iconData: Icons.bloodtype,
                      title: 'Diabetes Management',
                      color: color,
                      child: CardSection(
                        title: 'TECHNOLOGIES USED',
                        items: [
                          'PPARG-based glucose prediction',
                          'APOE-based ketogenic diet assessment',
                          'Microbiota modulation',
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.favorite_border,
                      title: 'Cardiovascular Disease Support',
                      color: color,
                      child: CardSection(
                        title: 'PROGRAMS INCLUDE',
                        items: [
                          'APOA5 / LPL gene testing',
                          'TMAO metabolic intervention',
                          'ACE-guided sodium sensitivity check',
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.healing,
                      title: 'Autoimmune Disease Care',
                      color: color,
                      child: CardSection(
                        title: 'INTERVENTIONS INCLUDE',
                        items: [
                          'Gluten/dairy cross-reactivity testing',
                          'VDR-based vitamin D3 dosing',
                          'Butyrate supplementation (SCFA therapy)',
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.monitor_weight_outlined,
                      title: 'Obesity Management',
                      color: color,
                      child: CardSection(
                        title: 'PRECISION METHODS INCLUDE',
                        items: [
                          'Hunger hormone genotyping (LEPR, MC4R)',
                          'Brown fat activators (Capsaicin, tea polyphenols)',
                          'Microbiota targeting (Akkermansia support)',
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
