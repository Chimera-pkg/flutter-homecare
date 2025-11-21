import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/booking_appointment/add_on_services/presentation/pages/add_on_service_page.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/bloc/nursing_appointment_flow_bloc.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/bloc/schedule_appointment_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/pages/health_status_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/pages/personal_issues_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/search_professional_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/professional_details_page.dart';
import 'package:m2health/route/app_routes.dart';
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

  void _onBack(BuildContext context) {
    final state = context.read<NursingAppointmentFlowBloc>().state;
    final flowBloc = context.read<NursingAppointmentFlowBloc>();

    if (state.submissionStatus == AppointmentSubmissionStatus.submitting) {
      return; // Prevent back navigation during submission
    }

    switch (state.currentStep) {
      case NursingFlowStep.personalCase:
        Navigator.pop(context);
        break;
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
        flowBloc.add(const FlowStepChanged(NursingFlowStep.searchProfessional));
        break;
      case NursingFlowStep.scheduling:
        flowBloc
            .add(const FlowStepChanged(NursingFlowStep.viewProfessionalDetail));
        break;
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
              backgroundColor: Colors.red,
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
                    serviceType: 'nursing',
                    getPersonalIssues: sl(),
                    createPersonalIssue: sl(),
                    deletePersonalIssue: sl(),
                  ),
                  child: PersonalIssuesPage(
                    onIssuesSelected: (issues) {
                      context
                          .read<NursingAppointmentFlowBloc>()
                          .add(FlowPersonalIssueUpdated(issues));
                    },
                  ),
                ),
                HealthStatusPage(
                  initialHealthStatus: state.healthStatus,
                  onSubmit: (healthStatus) {
                    context
                        .read<NursingAppointmentFlowBloc>()
                        .add(FlowHealthStatusUpdated(healthStatus));
                  },
                ),
                AddOnServicePage(
                  serviceType: state.serviceType.apiValue,
                  initialSelectedServices: state.selectedAddOnServices,
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
                    role: 'nurse',
                    serviceIds: state.selectedAddOnServices.map((e) => e.id).toList(),
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
                      professionalId: state.selectedProfessional!.id,
                      role: state.selectedProfessional?.role ?? 'nurse',
                      onButtonPressed: () {
                        context.read<NursingAppointmentFlowBloc>().add(
                            const FlowStepChanged(NursingFlowStep.scheduling));
                      },
                    ),
                  ), // Placeholder
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
                            .read<NursingAppointmentFlowBloc>()
                            .add(FlowTimeSlotSelected(timeSlot));
                      },
                    )),
                  ), // Placeholder
              ],
            ),
          ),
        );
      },
    );
  }
}
