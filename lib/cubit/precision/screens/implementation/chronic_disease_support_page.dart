import 'package:flutter/material.dart';
import 'package:m2health/cubit/precision/widgets/precision_widgets.dart';

class ChronicDiseaseSupportPage extends StatelessWidget {
  const ChronicDiseaseSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Chronic-Disease Support'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FeatureDetailCard(
                      iconData: Icons.bloodtype,
                      title: 'Diabetes Management',
                      borderColor: Color(0xFF5782F1),
                      sections: {
                        'TECHNOLOGIES USED': [
                          'PPARG-based glucose prediction',
                          'APOE-based ketogenic diet assessment',
                          'Microbiota modulation',
                        ],
                      },
                    ),
                    FeatureDetailCard(
                      iconData: Icons.favorite_border,
                      title: 'Cardiovascular Disease Support',
                      borderColor: Color(0xFFF76F8E),
                      sections: {
                        'PROGRAMS INCLUDE': [
                          'APOA5 / LPL gene testing',
                          'TMAO metabolic intervention',
                          'ACE-guided sodium sensitivity check',
                        ],
                      },
                    ),
                    FeatureDetailCard(
                      iconData: Icons.healing,
                      title: 'Autoimmune Disease Care',
                      borderColor: Color(0xFF9AE1FF),
                      sections: {
                        'INTERVENTIONS INCLUDE': [
                          'Gluten/dairy cross-reactivity testing',
                          'VDR-based vitamin D3 dosing',
                          'Butyrate supplementation (SCFA therapy)',
                        ],
                      },
                    ),
                    FeatureDetailCard(
                      iconData: Icons.monitor_weight_outlined,
                      title: 'Obesity Management',
                      borderColor: Color(0xFF10B981),
                      sections: {
                        'PRECISION METHODS INCLUDE': [
                          'Hunger hormone genotyping (LEPR, MC4R)',
                          'Brown fat activators (Capsaicin, tea polyphenols)',
                          'Microbiota targeting (Akkermansia support)',
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
