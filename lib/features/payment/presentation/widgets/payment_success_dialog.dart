import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/appointment/appointment_module.dart';
import 'package:m2health/features/payment/domain/entities/payment.dart';
import 'package:m2health/features/payment/presentation/cubit/feedback_cubit.dart';
import 'package:m2health/features/payment/presentation/pages/feedback_form_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class PaymentSuccessDialog extends StatelessWidget {
  final Payment payment;
  final AppointmentEntity appointment;

  const PaymentSuccessDialog({
    super.key,
    required this.payment,
    required this.appointment,
  });

  String get professionalName => appointment.provider != null
      ? appointment.provider!.name
      : 'the professional';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0), // Add padding for the close button
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/ic_checklist.png',
                  width: 142,
                  height: 142,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Payment Success',
                  style: TextStyle(
                    color: Const.aqua,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your money has been successfully sent to $professionalName.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount'),
                    Text(
                      '\$${payment.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 34),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 32,
                ),
                const Text(
                  'How is your experience?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your feedback will help us to improve your\nexperience better',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (BuildContext context) {
                          return BlocProvider(
                            create: (context) =>
                                FeedbackCubit(submitFeedbackUseCase: sl()),
                            child: FeedbackFormPage(
                              appointment: appointment,
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Const.aqua,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Please Feedback',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<AppointmentCubit>().refreshAllTabs();
                      context.go(AppRoutes.appointment);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(
                        color: Const.aqua,
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'Return to Home',
                      style: TextStyle(
                        color: Const.aqua,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ),
        ],
      ),
    );
  }
}
