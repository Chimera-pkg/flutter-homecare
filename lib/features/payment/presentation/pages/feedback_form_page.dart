import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/payment/presentation/cubit/feedback_cubit.dart';
import 'package:m2health/features/payment/presentation/pages/feedback_success_page.dart';
import 'package:m2health/route/app_routes.dart';

class FeedbackFormPage extends StatefulWidget {
  final AppointmentEntity appointment;

  const FeedbackFormPage({super.key, required this.appointment});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  int selectedStar = 5;
  String selectedTip = '';
  bool showOtherAmountField = false;

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _otherAmountController = TextEditingController();

  String get professionalName =>
      widget.appointment.provider?.name ?? 'the professional';

  @override
  void dispose() {
    _textController.dispose();
    _otherAmountController.dispose();
    super.dispose();
  }

  void _onSubmitFeedback() {
    final String? tips = showOtherAmountField
        ? _otherAmountController.text
        : (selectedTip.isNotEmpty ? selectedTip : null);

    if (widget.appointment.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Appointment ID is missing.')),
      );
      return;
    }

    context.read<FeedbackCubit>().submitFeedback(
          appointmentId: widget.appointment.id!,
          stars: selectedStar,
          text: _textController.text.isNotEmpty ? _textController.text : null,
          tips: tips,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackCubit, FeedbackState>(
      listener: (context, state) {
        if (state is FeedbackSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackSuccessPage(
                onButtonPressed: () {
                  // Go to appointment detail and clear the stack
                  GoRouter.of(context).goNamed(AppRoutes.appointmentDetail,
                      extra: widget.appointment.id!);
                },
              ),
            ),
          );
        } else if (state is FeedbackFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Feedback Failed: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star_rounded,
                        color: index < selectedStar
                            ? const Color(0xFFFBC02D)
                            : Colors.grey,
                        size: 36,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedStar = index + 1;
                        });
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Excellent',
                  style: TextStyle(
                    color: Const.aqua,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'You rated $professionalName $selectedStar stars',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Write your text',
                  border: OutlineInputBorder(),
                ),
                minLines: 5,
                maxLines: 8,
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Give some tips to $professionalName',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTipCard('\$1'),
                  _buildTipCard('\$2'),
                  _buildTipCard('\$5'),
                  _buildTipCard('\$10'),
                  _buildTipCard('\$20'),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showOtherAmountField = true;
                    });
                  },
                  child: const Text(
                    'Enter other amount',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Const.aqua,
                    ),
                  ),
                ),
              ),
              if (showOtherAmountField) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _otherAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter amount',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<FeedbackCubit, FeedbackState>(
                    builder: (context, state) {
                      final isLoading = state is FeedbackLoading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _onSubmitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Const.aqua,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : const Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String amount) {
    bool isSelected = selectedTip == amount;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTip = amount;
          showOtherAmountField = false;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Const.tosca : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isSelected ? Const.tosca : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
