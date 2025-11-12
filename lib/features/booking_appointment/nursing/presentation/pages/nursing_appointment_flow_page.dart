import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/add_on_services/presentation/pages/add_on_service_page.dart';
import 'package:m2health/features/appointment/pages/appointment_detail.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/bloc/nursing_appointment_flow_bloc.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/pages/health_status_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/pages/personal_issues_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/search_professional_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/professional_details_page.dart';
import 'package:m2health/service_locator.dart';

class NursingAppointmentFlowPage extends StatefulWidget {
  const NursingAppointmentFlowPage({super.key});

  @override
  State<NursingAppointmentFlowPage> createState() =>
      _NursingAppointmentFlowPageState();
}

class _NursingAppointmentFlowPageState
    extends State<NursingAppointmentFlowPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // This is our new, unified back button logic
  void _onBack(BuildContext context) {
    final state = context.read<NursingAppointmentFlowBloc>().state;
    final flowBloc = context.read<NursingAppointmentFlowBloc>();

    if (state.submissionStatus == AppointmentSubmissionStatus.submitting) {
      return; // Prevent back navigation during submission
    }

    if (state.currentStep == NursingFlowStep.personalCase) {
      // First step: pop the whole flow
      Navigator.pop(context);
    } else {
      // Other steps: send a "go back" event to the BLoC.
      // The listener will handle the page animation.
      switch (state.currentStep) {
        case NursingFlowStep.healthStatus:
          flowBloc.add(const FlowStepChanged(NursingFlowStep.personalCase));
          break;
        case NursingFlowStep.addOnService:
          flowBloc.add(const FlowStepChanged(NursingFlowStep.healthStatus));
          break;
        case NursingFlowStep.searchProfessional:
          flowBloc.add(const FlowStepChanged(NursingFlowStep.addOnService));
          break;
        case NursingFlowStep.viewProfessionalDetail:
          flowBloc
              .add(const FlowStepChanged(NursingFlowStep.searchProfessional));
          break;
        case NursingFlowStep.scheduling:
          flowBloc.add(
              const FlowStepChanged(NursingFlowStep.viewProfessionalDetail));
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NursingAppointmentFlowBloc,
        NursingAppointmentFlowState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus ||
          previous.currentStep != current.currentStep,
      listener: (context, state) {
        // --- Handle Submission ---
        if (state.submissionStatus == AppointmentSubmissionStatus.success &&
            state.createdAppointment != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment created successfully')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DetailAppointmentPage(
                appointmentId: state.createdAppointment!.id!,
              ),
            ),
          );
        }
        if (state.submissionStatus == AppointmentSubmissionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Failed to create appointment',
              ),
            ),
          );
        }

        if (state.currentStep.index != _pageController.page?.round()) {
          _pageController.animateToPage(
            state.currentStep.index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) return;
            _onBack(context);
          },
          child: Scaffold(
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PersonalIssuesPage(
                  serviceType: 'nurse',
                  onIssuesSelected: (issues) {
                    context
                        .read<NursingAppointmentFlowBloc>()
                        .add(FlowPersonalIssueUpdated(issues));
                  },
                ),
                HealthStatusPage(
                  onSubmit: (healthStatus) {
                    context
                        .read<NursingAppointmentFlowBloc>()
                        .add(FlowHealthStatusUpdated(healthStatus));
                  },
                ),
                AddOnServicePage(
                  serviceType: state.serviceType.apiValue,
                  onComplete: (services) {
                    context
                        .read<NursingAppointmentFlowBloc>()
                        .add(FlowAddOnServicesUpdated(services));
                  },
                ),
                BlocProvider(
                  create: (context) => ProfessionalBloc(
                    getProfessionals: sl(),
                    toggleFavorite: sl(),
                  ),
                  child: SearchProfessionalPage(
                    serviceType: 'nurse',
                    onProfessionalSelected: (prof) {
                      context
                          .read<NursingAppointmentFlowBloc>()
                          .add(FlowProfessionalSelected(prof));
                    },
                  ),
                ),
                if (state.selectedProfessional != null)
                  BlocProvider(
                    create: (context) => ProfessionalDetailCubit(
                      getProfessionalDetail: sl(),
                    ),
                    child: ProfessionalDetailsPage(
                      // Handle null professional for the first build
                      professionalId: state.selectedProfessional!.id,
                      serviceType: state.selectedProfessional?.role ?? 'nurse',
                      onButtonPressed: () {
                        context.read<NursingAppointmentFlowBloc>().add(
                            const FlowStepChanged(NursingFlowStep.scheduling));
                      },
                    ),
                  ), // Placeholder
                if (state.selectedProfessional != null)
                  ScheduleAppointmentPage(
                    // Handle null professional for the first build
                    professional: state.selectedProfessional!,
                    isSubmitting: state.submissionStatus ==
                        AppointmentSubmissionStatus.submitting,
                    onTimeSlotSelected: (timeSlot) {
                      context
                          .read<NursingAppointmentFlowBloc>()
                          .add(FlowTimeSlotSelected(timeSlot));
                    },
                  ), // Placeholder
              ],
            ),
          ),
        );
      },
    );
  }
}
