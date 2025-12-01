import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/booking_appointment/add_on_services/presentation/pages/add_on_service_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_cubit.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/pages/health_status_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/pages/personal_issues_page.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/bloc/pharmacy_appointment_flow_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/professional_details_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/search_professional_page.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/bloc/schedule_appointment_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';

import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class PharmacyAppointmentFlowPage extends StatefulWidget {
  const PharmacyAppointmentFlowPage({super.key});

  @override
  State<PharmacyAppointmentFlowPage> createState() =>
      PharmacyAppointmentFlowPageState();
}

class PharmacyAppointmentFlowPageState
    extends State<PharmacyAppointmentFlowPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBack(BuildContext context) {
    final state = context.read<PharmacyAppointmentFlowBloc>().state;
    final flowBloc = context.read<PharmacyAppointmentFlowBloc>();

    if (state.submissionStatus == AppointmentSubmissionStatus.submitting) {
      return;
    }

    switch (state.currentStep) {
      case PharmacyFlowStep.personalCase:
        Navigator.pop(context); // Exit the flow
        break;
      case PharmacyFlowStep.healthStatus:
        flowBloc.add(const FlowStepChanged(PharmacyFlowStep.personalCase));
        break;
      case PharmacyFlowStep.addOnService:
        flowBloc.add(const FlowStepChanged(PharmacyFlowStep.healthStatus));
        break;
      case PharmacyFlowStep.searchProfessional:
        flowBloc.add(const FlowStepChanged(PharmacyFlowStep.addOnService));
        break;
      case PharmacyFlowStep.viewProfessionalDetail:
        flowBloc
            .add(const FlowStepChanged(PharmacyFlowStep.searchProfessional));
        break;
      case PharmacyFlowStep.scheduling:
        flowBloc.add(
            const FlowStepChanged(PharmacyFlowStep.viewProfessionalDetail));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PharmacyAppointmentFlowBloc,
        PharmacyAppointmentFlowState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus ||
          previous.currentStep != current.currentStep,
      listener: (context, state) {
        // --- Handle Submission ---
        if (state.submissionStatus == AppointmentSubmissionStatus.success &&
            state.createdAppointment != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment created successfully'),
              backgroundColor: Colors.green,
            ),
          );
          GoRouter.of(context).goNamed(
            AppRoutes.appointmentDetail,
            extra: state.createdAppointment!.id!,
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
                BlocProvider(
                  create: (context) => PersonalIssuesCubit(
                    serviceType: 'pharmacy',
                    getPersonalIssues: sl(),
                    createPersonalIssue: sl(),
                    updatePersonalIssue: sl(),
                    deletePersonalIssue: sl(),
                  ),
                  child: PersonalIssuesPage(
                    initialSelectedIssues: state.selectedIssues,
                    onIssuesSelected: (issues) {
                      context
                          .read<PharmacyAppointmentFlowBloc>()
                          .add(FlowPersonalIssueUpdated(issues));
                    },
                  ),
                ),
                HealthStatusPage(
                  initialHealthStatus: state.healthStatus,
                  onSubmit: (healthStatus) {
                    context
                        .read<PharmacyAppointmentFlowBloc>()
                        .add(FlowHealthStatusUpdated(healthStatus));
                  },
                ),
                AddOnServicePage(
                  serviceType: 'pharmacy',
                  initialSelectedServices: state.selectedAddOnServices,
                  onComplete: (services) {
                    context
                        .read<PharmacyAppointmentFlowBloc>()
                        .add(FlowAddOnServicesUpdated(services));
                  },
                ),
                BlocProvider(
                  create: (context) => ProfessionalBloc(
                    getProfessionals: sl(),
                    toggleFavorite: sl(),
                  ),
                  child: SearchProfessionalPage(
                    role: 'pharmacist',
                    serviceIds:
                        state.selectedAddOnServices.map((e) => e.id).toList(),
                    onProfessionalSelected: (prof) {
                      context
                          .read<PharmacyAppointmentFlowBloc>()
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
                      professionalId: state.selectedProfessional!.id,
                      role: 'pharmacist',
                      onButtonPressed: () {
                        context.read<PharmacyAppointmentFlowBloc>().add(
                            const FlowStepChanged(PharmacyFlowStep.scheduling));
                      },
                    ),
                  ),
                if (state.selectedProfessional != null)
                  BlocProvider(
                    create: (context) => ScheduleAppointmentCubit(
                      getAvailableTimeSlots: sl(),
                      rescheduleAppointment: sl(),
                    ),
                    child: ScheduleAppointmentPage(
                      data: ScheduleAppointmentPageData(
                        professional: state.selectedProfessional!,
                        isSubmitting: state.submissionStatus ==
                            AppointmentSubmissionStatus.submitting,
                        onTimeSlotSelected: (timeSlot) {
                          context
                              .read<PharmacyAppointmentFlowBloc>()
                              .add(FlowTimeSlotSelected(timeSlot));
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
