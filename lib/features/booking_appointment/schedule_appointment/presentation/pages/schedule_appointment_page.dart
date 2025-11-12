import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/bloc/schedule_appointment_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/widgets/time_slot_grid_view.dart';
import 'package:m2health/service_locator.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleAppointmentPage extends StatelessWidget {
  final ProfessionalEntity professional;
  final bool isSubmitting;
  final Function(DateTime)? onTimeSlotSelected;
  final AppointmentEntity? currentAppointment; // For reschedule mode

  const ScheduleAppointmentPage({
    super.key,
    required this.professional,
    this.isSubmitting = false,
    this.onTimeSlotSelected,
    this.currentAppointment,
  });

  @override
  Widget build(BuildContext context) {
    // This page provides its own Cubit
    return BlocProvider(
      create: (context) =>
          ScheduleAppointmentCubit(getAvailableTimeSlots: sl()),
      child: _ScheduleAppointmentView(
        professional: professional,
        isSubmitting: isSubmitting,
        onTimeSlotSelected: onTimeSlotSelected,
        currentAppointment: currentAppointment,
      ),
    );
  }
}

class _ScheduleAppointmentView extends StatefulWidget {
  final ProfessionalEntity professional;
  final bool isSubmitting;
  final Function(DateTime)? onTimeSlotSelected;
  final AppointmentEntity? currentAppointment;

  const _ScheduleAppointmentView({
    required this.professional,
    this.isSubmitting = false,
    this.onTimeSlotSelected,
    this.currentAppointment,
  });

  @override
  State<_ScheduleAppointmentView> createState() =>
      _ScheduleAppointmentViewState();
}

class _ScheduleAppointmentViewState extends State<_ScheduleAppointmentView> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  bool get isRescheduleMode => widget.currentAppointment != null;

  @override
  void initState() {
    super.initState();
    _fetchSlots(DateTime.now());
  }

  void _submit() {
    final selectedTime =
        context.read<ScheduleAppointmentCubit>().state.selectedTime;

    if (selectedTime == null) {
      log('No time slot selected on submit', name: 'ScheduleAppointmentView');
      return;
    }

    if (widget.onTimeSlotSelected != null) {
      widget.onTimeSlotSelected!(selectedTime);
      return;
    }

    if (isRescheduleMode) {
      final appointmentId = widget.currentAppointment!.id!;
      context.read<ScheduleAppointmentCubit>().rescheduleAppointment(
            appointmentId: appointmentId,
            newTime: selectedTime,
          );
    }
  }

  void _fetchSlots(DateTime date) async {
    final currentlyBookedSlot = widget.currentAppointment != null
        ? TimeSlot(
            startTime: widget.currentAppointment!.startDatetime,
            endTime: widget.currentAppointment!.endDatetime!,
          )
        : null;

    await context.read<ScheduleAppointmentCubit>().fetchSlots(
          providerId: widget.professional.id,
          providerType: widget.professional.role.toLowerCase(),
          date: date,
          currentlyBookedSlot: currentlyBookedSlot,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Schedule',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfessionalCard(),
            const SizedBox(height: 24),
            const Text(
              'Select Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            _buildCalendar(),
            const SizedBox(height: 24),
            const Text(
              'Select Hour',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<ScheduleAppointmentCubit, ScheduleAppointmentState>(
              builder: (context, state) {
                if (state.status == ActionStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == ActionStatus.error) {
                  return Center(
                      child:
                          Text(state.errorMessage ?? 'Failed to load slots'));
                }
                if (state.slots.isEmpty) {
                  return const Center(
                      child: Text('No available slots for this day.'));
                }

                return TimeSlotGridView(
                  timeSlots: state.slots,
                  selectedTime: state.selectedTime,
                  onTimeSelected: (time) {
                    context.read<ScheduleAppointmentCubit>().selectTime(time);
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildProfessionalCard() {
    final professional = widget.professional;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  professional.avatar ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 25,
                      color: Colors.grey[600],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(professional.role),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.teal, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          professional.workplace ?? 'Unknown Location',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        color: const Color.fromRGBO(154, 225, 255, 0.1),
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          availableGestures: AvailableGestures.none,
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 90)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            log('Selected Day: $selectedDay', name: '_buildCalendar');
            _fetchSlots(selectedDay);
          },
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: Colors.grey,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
              color: Const.aqua,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              border: Border.all(color: Const.aqua.withValues(alpha: 0.5)),
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600),
            selectedTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            markerDecoration: const BoxDecoration(
              color: Const.aqua,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: const TextStyle(color: Colors.black),
            defaultTextStyle: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: BlocConsumer<ScheduleAppointmentCubit, ScheduleAppointmentState>(
        listenWhen: (previous, current) =>
            previous.rescheduleStatus != current.rescheduleStatus,
        listener: (context, state) {
          if (state.rescheduleStatus == ActionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appointment rescheduled successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true); // Indicate success
          } else if (state.rescheduleStatus == ActionStatus.error) {
            final errorMessage =
                state.rescheduleErrorMessage ?? 'Rescheduling failed.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isButtonDisabled =
              state.selectedTime == null || widget.isSubmitting;
          return ElevatedButton(
            onPressed: isButtonDisabled ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF35C5CF),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: widget.isSubmitting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Submitting...',
                          style: TextStyle(color: Colors.white)),
                    ],
                  )
                : const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
          );
        },
      ),
    );
  }
}
