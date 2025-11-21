import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/home_health_screening/presentation/bloc/home_health_screening_flow_bloc.dart';
import 'package:m2health/features/home_health_screening/presentation/bloc/services_list/screening_services_cubit.dart';
import 'package:m2health/features/home_health_screening/presentation/pages/screening_services_selection_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional/professional_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_cubit.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/professional_details_page.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/pages/search_professional_page.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/bloc/schedule_appointment_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/service_locator.dart';

class HomeHealthScreeningFlowPage extends StatefulWidget {
  const HomeHealthScreeningFlowPage({super.key});

  @override
  State<HomeHealthScreeningFlowPage> createState() =>
      _HomeHealthScreeningFlowPageState();
}

class _HomeHealthScreeningFlowPageState
    extends State<HomeHealthScreeningFlowPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBack(BuildContext context) {
    final state = context.read<HomeHealthScreeningFlowBloc>().state;
    final flowBloc = context.read<HomeHealthScreeningFlowBloc>();

    if (state.submissionStatus == ScreeningSubmissionStatus.submitting) return;

    switch (state.currentStep) {
      case HomeHealthScreeningStep.selectServices:
        Navigator.pop(context);
        break;
      case HomeHealthScreeningStep.searchProfessional:
        flowBloc.add(const ScreeningFlowStepChanged(
            HomeHealthScreeningStep.selectServices));
        break;
      case HomeHealthScreeningStep.viewProfessionalDetail:
        flowBloc.add(const ScreeningFlowStepChanged(
            HomeHealthScreeningStep.searchProfessional));
        break;
      case HomeHealthScreeningStep.scheduling:
        flowBloc.add(const ScreeningFlowStepChanged(
            HomeHealthScreeningStep.viewProfessionalDetail));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeHealthScreeningFlowBloc,
        HomeHealthScreeningFlowState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus ||
          previous.currentStep != current.currentStep,
      listener: (context, state) {
        if (state.submissionStatus == ScreeningSubmissionStatus.success &&
            state.createdAppointment != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Screening appointment booked successfully!'),
            backgroundColor: Colors.green,
          ));
          GoRouter.of(context).goNamed(AppRoutes.appointmentDetail,
              extra: state.createdAppointment!.id!);
        }

        if (state.submissionStatus == ScreeningSubmissionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? 'Booking failed'),
            backgroundColor: Colors.red,
          ));
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
          onPopInvoked: (didPop) {
            if (didPop) return;
            _onBack(context);
          },
          child: Scaffold(
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Select Services
                BlocProvider(
                  create: (_) => ScreeningServicesCubit(sl()),
                  child: ScreeningServicesSelectionPage(
                    initialSelection: state.selectedItems,
                    onNext: (items) {
                      context
                          .read<HomeHealthScreeningFlowBloc>()
                          .add(ScreeningItemsUpdated(items));
                    },
                  ),
                ),

                // Step 2: Select Professionals (Filter role='nurse')
                BlocProvider(
                  create: (_) => ProfessionalBloc(
                      getProfessionals: sl(), toggleFavorite: sl()),
                  child: SearchProfessionalPage(
                    role: 'nurse',
                    onProfessionalSelected: (prof) {
                      context
                          .read<HomeHealthScreeningFlowBloc>()
                          .add(ScreeningProfessionalSelected(prof));
                    },
                  ),
                ),

                // Step 3: View Nurse Detail
                if (state.selectedProfessional != null)
                  BlocProvider(
                    create: (_) =>
                        ProfessionalDetailCubit(getProfessionalDetail: sl()),
                    child: ProfessionalDetailsPage(
                      professionalId: state.selectedProfessional!.id,
                      role: 'nurse',
                      onButtonPressed: () {
                        context.read<HomeHealthScreeningFlowBloc>().add(
                            const ScreeningFlowStepChanged(
                                HomeHealthScreeningStep.scheduling));
                      },
                    ),
                  ),

                // Step 4: Pick Time & Submit
                if (state.selectedProfessional != null)
                  BlocProvider(
                    create: (_) => ScheduleAppointmentCubit(
                      getAvailableTimeSlots: sl(),
                      rescheduleAppointment: sl(),
                    ),
                    child: ScheduleAppointmentPage(
                      data: ScheduleAppointmentPageData(
                        professional: state.selectedProfessional!,
                        isSubmitting: state.submissionStatus ==
                            ScreeningSubmissionStatus.submitting,
                        onTimeSlotSelected: (timeSlot) {
                          context
                              .read<HomeHealthScreeningFlowBloc>()
                              .add(ScreeningTimeSlotSelected(timeSlot));
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
