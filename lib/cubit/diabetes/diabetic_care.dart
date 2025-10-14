import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/app_localzations.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/route/app_routes.dart';

class DiabeticCare extends StatelessWidget {
  const DiabeticCare({super.key});

  List<Map<String, String>> get diabeticCareMenus => [
        {
          'title': 'Diabetic Retinal\nPhotography (DRP)',
          'description':
              'A common eye disease among diabetic\npatients. Blood capillaries may bleed\nand damage the retina, potentially\nleading to blindness. Regular\ndiabetic retinal photography\ncan detect and monitor your eyes.',
          'imagePath': 'assets/images/ilu_diabet_retina.png',
          'color': '9AE1FF',
          'opacity': '0.33',
        },
        {
          'title': 'Diabetic Foot Screening\n (DFS)',
          'description':
              'Conducted by trained nurses, who will\nalso educate on proper footcare and\ngood sugar control. Referrals to\nfootcare specialists will be made\nwhere appropriate.',
          'imagePath': 'assets/images/ilu_diabet_foot.png',
          'color': 'B28CFF',
          'opacity': '0.2',
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('diabetic_care2'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: diabeticCareMenus.length,
                itemBuilder: (context, index) {
                  final menu = diabeticCareMenus[index];
                  return BlocBuilder<DiabetesFormCubit, DiabetesFormState>(
                    builder: (context, state) {
                      return DiabeticCard(
                        pharma: menu,
                        isLoading: state.isLoading,
                        onTap: () async {
                          final bool hasForm = await context
                              .read<DiabetesFormCubit>()
                              .loadForm();
                          if (!context.mounted) return;
                          if (hasForm) {
                            GoRouter.of(context)
                                .goNamed(AppRoutes.diabeticProfileSummary);
                          } else {
                            GoRouter.of(context)
                                .goNamed(AppRoutes.diabeticProfileForm);
                          }
                        },
                        color: Color(int.parse('0xFF${menu['color']}'))
                            .withValues(
                                alpha: menu['opacity'] != null
                                    ? double.parse(menu['opacity']!)
                                    : 1.0),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiabeticCard extends StatelessWidget {
  final Map<String, String> pharma;
  final VoidCallback? onTap;
  final Color color;
  final bool isLoading;

  const DiabeticCard({
    super.key,
    required this.pharma,
    required this.onTap,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: 360,
        height: 260,
        padding: const EdgeInsets.all(16.0),
        color: color.withValues(
            alpha: 0.1), // Set the background color with 10% opacity
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pharma['title']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${pharma['description']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400, // Light font weight
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: isLoading ? null : onTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 5),
                      const Text(
                        'Book Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF35C5CF),
                        ),
                      ),
                      const SizedBox(width: 5),
                      isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Const.aqua,
                              ),
                            )
                          : Image.asset(
                              'assets/icons/ic_play.png',
                              width: 20,
                              height: 20,
                            ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: -25,
              right: -20,
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0), // Adjust the padding as needed
                  child: Image.asset(
                    pharma['imagePath']!,
                    width: 185,
                    height: 139,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
