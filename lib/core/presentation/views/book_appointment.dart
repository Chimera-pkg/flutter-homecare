import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/data/models/provider.dart';
import 'package:m2health/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'details/detail_appointment.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/time_slot_grid_view.dart';
import 'package:m2health/core/services/appointment_service.dart';

class BookAppointmentPageData {
  final Provider provider;
  final int? appointmentId; // Optional appointment ID for rescheduling
  final DateTime? initialDate; // Optional initial date for rescheduling
  final DateTime? initialTime; // Optional initial time for rescheduling

  const BookAppointmentPageData({
    required this.provider,
    this.appointmentId,
    this.initialDate,
    this.initialTime,
  });

  @override
  String toString() {
    return 'BookAppointmentPageData(provider: $provider, appointmentId: $appointmentId, initialDate: $initialDate, initialTime: $initialTime)';
  }
}

class BookAppointmentPage extends StatefulWidget {
  final BookAppointmentPageData data;

  const BookAppointmentPage({
    super.key,
    required this.data,
  });

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime selectTime;
  late AppointmentService _appointmentService;
  late bool isReschedule;
  bool _isSubmitting = false; // Add loading state to prevent duplicates

  @override
  void initState() {
    super.initState();
    // Use initial values if provided, otherwise default to now
    _selectedDay = widget.data.initialDate ?? DateTime.now();
    _focusedDay = widget.data.initialDate ?? DateTime.now();
    selectTime = widget.data.initialTime ?? DateTime.now();
    isReschedule = widget.data.appointmentId != null;
    _appointmentService = AppointmentService(context.read<Dio>());
  }

  Future<void> _submitAppointment() async {
    // Prevent duplicate submissions
    if (_isSubmitting) {
      log('Already submitting appointment, ignoring duplicate request');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final userId = await Utils.getSpString(Const.USER_ID);

      // Extract provider information from the Provider model
      final provider = widget.data.provider;

      log('Provider ID: ${provider.id}');
      log('Provider Type: ${provider.providerType}');
      log('Provider Data: $provider');

      if (isReschedule) {
        // Update existing appointment
        await _appointmentService.updateAppointment(
          widget.data.appointmentId!,
          {
            'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
            'hour': DateFormat('HH:mm').format(selectTime),
          },
        );

        log('Appointment rescheduled successfully');
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment rescheduled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        log('Appointment created successfully');

        // Navigate to appointment detail page
        final appointmentData = {
          'user_id': int.tryParse(userId ?? '1') ?? 1,
          'provider_id': provider.id,
          'provider_type': provider.providerType.toLowerCase(),
          'type': provider.providerType,
          'status': 'pending',
          'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
          'hour': DateFormat('HH:mm').format(selectTime),
          'summary': 'Appointment booking with ${provider.name}',
          'pay_total': 100.0,
          'profile_services_data': provider.toJson(),
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailAppointmentPage(
              appointmentData: appointmentData,
            ),
          ),
        );
      }
    } catch (e) {
      log('=== APPOINTMENT CREATION ERROR ===');
      log('Error: $e');

      // Enhanced error logging for debugging
      if (e is DioException && e.response != null) {
        log('Status Code: ${e.response!.statusCode}');
        log('Response Data: ${e.response!.data}');
        log('Request Data: ${e.requestOptions.data}');
      }

      String errorMessage = 'Failed to create appointment';
      if (e.toString().contains('Validation error') ||
          e.toString().contains('E_VALIDATION_FAILURE')) {
        errorMessage = 'Please check your appointment details and try again';
      } else if (e.toString().contains('422')) {
        errorMessage =
            'Invalid appointment data. Provider may not be available or data is incomplete. Please verify all fields are correct';
      } else if (e.toString().contains('provider_id')) {
        errorMessage =
            'Provider information is missing. Please select a provider again.';
      } else if (e.toString().contains('provider_type')) {
        errorMessage =
            'Provider type is missing. Please select a provider again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Always reset the submitting state
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.data.provider;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isReschedule ? 'Reschedule Appointment' : 'Book Appointment',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9AE1FF).withOpacity(0.33),
                      const Color(0xFF9DCEFF).withOpacity(0.33),
                    ],
                    end: Alignment.topLeft,
                    begin: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
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
                            provider.avatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/images_budi.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(provider.providerType),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.teal),
                              const SizedBox(width: 4),
                              Text(provider.workplace),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF9AE1FF).withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(color: Colors.black),
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
                    color: Const.tosca,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Const.tosca.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Const.tosca,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: const TextStyle(color: Colors.black),
                  defaultTextStyle: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Hour',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimeSlotGridView(
                  startTime: DateTime(2023, 1, 1, 9, 0),
                  endTime: DateTime(2023, 1, 1, 18, 0),
                  selectedTime: selectTime,
                  onTimeSelected: (time) {
                    setState(() {
                      selectTime = time;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitAppointment,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isSubmitting
                ? const Color(0xFF35C5CF).withOpacity(0.6)
                : const Color(0xFF35C5CF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ), // Disable when submitting
          child: _isSubmitting
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Submitting...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : Text(
                  widget.data.appointmentId != null ? 'Reschedule' : 'Next',
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
