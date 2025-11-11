import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:m2health/features/nursingclean/presentation/pages/details/detail_appointment.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/time_slot_grid_view.dart';
import 'package:m2health/core/services/appointment_service.dart';

class BookAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> pharmacist;
  final int? appointmentId; // Optional appointment ID for rescheduling
  final DateTime? initialDate; // Optional initial date for rescheduling
  final DateTime? initialTime; // Optional initial time for rescheduling

  const BookAppointmentPage({
    Key? key,
    required this.pharmacist,
    this.appointmentId,
    this.initialDate,
    this.initialTime,
  }) : super(key: key);

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime selectTime;
  late AppointmentService _appointmentService;
  bool _isSubmitting = false; // Add loading state to prevent duplicates

  @override
  void initState() {
    super.initState();
    // Use initial values if provided, otherwise default to now
    _selectedDay = widget.initialDate ?? DateTime.now();
    _focusedDay = widget.initialDate ?? DateTime.now();
    selectTime = widget.initialTime ?? DateTime.now();
    _appointmentService = AppointmentService(context.read<Dio>());
  }

  Future<void> _submitAppointment() async {
    // Prevent duplicate submissions
    if (_isSubmitting) {
      print('Already submitting appointment, ignoring duplicate request');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final userId = await Utils.getSpString(Const.USER_ID);

      // Extract provider information from pharmacist data
      final providerId = widget.pharmacist['id'];
      final providerType = widget.pharmacist['role'] ?? 'pharmacist';

      print('Provider ID: $providerId');
      print('Provider Type: $providerType');
      print('Pharmacist data: ${widget.pharmacist}');

      if (providerId == null) {
        throw Exception(
            'Provider ID is required but not found in pharmacist data');
      }

      final appointmentData = {
        'user_id': int.tryParse(userId ?? '1') ?? 1,
        'provider_id': providerId, // Add provider_id
        'provider_type': providerType.toLowerCase(), // Add provider_type
        'type': providerType,
        'status': 'pending',
        'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
        'hour': DateFormat('HH:mm').format(selectTime),
        'summary':
            'Appointment booking with ${widget.pharmacist['name'] ?? 'provider'}',
        'pay_total': 100.0,
        'profile_services_data': widget.pharmacist,
      };

      print('Submitting appointment with data: $appointmentData');

      if (widget.appointmentId != null) {
        // Update existing appointment
        await _appointmentService.updateAppointment(
          widget.appointmentId!,
          appointmentData,
        );

        print('Appointment rescheduled successfully');
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment rescheduled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Create a new appointment
        final response =
            await _appointmentService.createAppointment(appointmentData);

        print('Appointment created successfully');

        // Navigate to appointment detail page
        final detailData = {
          'id': response['data']?['id'] ?? 0,
          'user_id': appointmentData['user_id'],
          'provider_id': appointmentData['provider_id'],
          'provider_type': appointmentData['provider_type'],
          'type': appointmentData['type'],
          'status': appointmentData['status'],
          'date': appointmentData['date'],
          'hour': appointmentData['hour'],
          'summary': appointmentData['summary'],
          'pay_total': appointmentData['pay_total'],
          'profile_services_data': appointmentData['profile_services_data'],
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailAppointmentPage(
              appointmentData: detailData,
            ),
          ),
        );
      }
    } catch (e) {
      print('=== APPOINTMENT CREATION ERROR ===');
      print('Error: $e');

      // Enhanced error logging for debugging
      if (e is DioException && e.response != null) {
        print('Status Code: ${e.response!.statusCode}');
        print('Response Data: ${e.response!.data}');
        print('Request Data: ${e.requestOptions.data}');
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
    final pharmacist = widget.pharmacist;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                      Color(0xFF9AE1FF).withOpacity(0.33),
                      Color(0xFF9DCEFF).withOpacity(0.33),
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
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(pharmacist['avatar']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pharmacist['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(pharmacist['role']),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.teal),
                              SizedBox(width: 4),
                              Text(pharmacist['maps_location']),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF9AE1FF).withOpacity(0.3),
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
                  weekendTextStyle: TextStyle(color: Colors.black),
                  defaultTextStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Hour',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimeSlot(
                  startTime: DateTime(2023, 1, 1, 9, 0),
                  endTime: DateTime(2023, 1, 1, 18, 0),
                  selectedTime: selectTime,
                  onTimeSelected: (time) {
                    setState(() {
                      selectTime = time;
                    });
                  },
                ),
                SizedBox(height: 16),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : _submitAppointment, // Disable when submitting
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
                  widget.appointmentId != null ? 'Reschedule' : 'Next',
                  style: const TextStyle(color: Colors.white),
                ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isSubmitting
                ? const Color(0xFF35C5CF).withOpacity(0.6)
                : const Color(0xFF35C5CF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
