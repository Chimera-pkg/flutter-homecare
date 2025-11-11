import 'package:flutter/material.dart';
import 'package:m2health/features/precision/screens/assessment/forms/health_history_screen.dart';
import 'package:m2health/features/precision/widgets/precision_widgets.dart';

class AntiAgingLongevityPage extends StatelessWidget {
  const AntiAgingLongevityPage({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF10B981);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Anti-Aging & Longevity'),
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
                      iconData: Icons.autorenew_outlined,
                      title: 'Cellular Regeneration & Mitochondrial Health',
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Improve cellular energy and delay biological aging.'),
                          CardSection(
                            title: 'APPLICABLE ISSUES',
                            items: [
                              'Low energy and fatigue',
                              'Brain fog issues',
                              'Poor digital medium',
                            ],
                          ),
                          CardSection(
                            title: 'INTERVENTION INCLUDE',
                            items: [
                              'NAD+ and mitochondria function testing',
                              'Autophagy and cellular rejuvenation plan',
                              'Personalized oxidative stress reduction',
                            ],
                          ),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.psychology_outlined,
                      title: 'Cognitive Longevity & Neuroprotection',
                      color: color, // Blue
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Enhance mental clarity, focus, and brain plasticity.'),
                          CardSection(
                            title: 'APPLICABLE ISSUES',
                            items: [
                              'Brain fog, memory issues, mental fatigue',
                              'APOE4-related cognitive risk',
                            ],
                          ),
                          CardSection(
                            title: 'INTERVENTION INCLUDE',
                            items: [
                              'Omega-3 Index and BDNF-related genotyping',
                              'Personalized MIND diet and nootropic nutrition plan',
                              'Gut-brain axis modulation',
                            ],
                          ),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.balance_outlined,
                      title: 'Hormonal Balance & Vitality optimization',
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Achieve optimal hormone levels and maintain youthful function.'),
                          CardSection(
                            title: 'APPLICABLE ISSUES',
                            items: [
                              'Hormonal decline (DHEA, estrogen, testosterone)',
                              'Subpar IGF-1 (blood biomarker)',
                              'Decline in strength',
                            ],
                          ),
                          CardSection(
                            title: 'INTERVENTION INCLUDE',
                            items: [
                              'Hormone-related genomic testing',
                              'Adaptogen and herbal support (ashwagandha, maca, etc)',
                              'Circadian rhythm and sleep optimization',
                            ],
                          ),
                        ],
                      ),
                    ),
                    FeatureDetailCard(
                      iconData: Icons.face_retouching_natural,
                      title: 'Skin & Structural Longevity',
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Maintain youthful skin and connective tissue health.'),
                          CardSection(
                            title: 'APPLICABLE ISSUES',
                            items: [
                              'Skin health, elasticity, wrinkles, joint stiffness',
                            ],
                          ),
                          CardSection(
                            title: 'INTERVENTION INCLUDE',
                            items: [
                              'Collagen-related genomic testing',
                              'Antioxidant-rich micronutrient protocol',
                              'Skin microbiome and hydration optimization program',
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
