import 'package:flutter/material.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_service_entity.dart';

class NursingServiceCard extends StatelessWidget {
  final NursingServiceEntity service;
  final VoidCallback onTap;

  const NursingServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  Color _getCardColor() {
    try {
      final String hexColor = service.color.replaceAll('#', '');
      final double opacity = double.tryParse(service.opacity) ?? 1.0;
      return Color(int.parse('0xFF$hexColor')).withOpacity(opacity);
    } catch (e) {
      return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        width: 357,
        height: 243,
        padding: const EdgeInsets.all(16.0),
        color: _getCardColor(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  service.description,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onTap,
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
                      Image.asset(
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
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Image.asset(
                    service.imagePath,
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
