import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/features/nursingclean/domain/entities/professional_entity.dart';
import 'package:m2health/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:m2health/features/nursing/pages/detail_appointment_page.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/time_slot_grid_view.dart';
import 'package:m2health/core/services/appointment_service.dart';

class BookAppointmentPage extends StatefulWidget {
  final ProfessionalEntity professional;
  final int? appointmentId; // Optional appointment ID for rescheduling
  final DateTime? initialDate; // Optional initial date for rescheduling
  final DateTime? initialTime; // Optional initial time for rescheduling

  const BookAppointmentPage({
    Key? key,
    required this.professional,
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
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate ?? DateTime.now();
    _focusedDay = widget.initialDate ?? DateTime.now();
    selectTime = widget.initialTime ?? DateTime.now();
    _appointmentService = AppointmentService(context.read<Dio>());
  }

  Future<void> _submitAppointment() async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final userId = await Utils.getSpString(Const.USER_ID);
      final providerId = widget.professional.id;
      final providerType = widget.professional.role;

      final appointmentData = {
        'user_id': int.tryParse(userId ?? '1') ?? 1,
        'provider_id': providerId,
        'provider_type': providerType.toLowerCase(),
        'type': providerType,
        'status': 'pending',
        'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
        'hour': DateFormat('HH:mm').format(selectTime),
        'summary': 'Appointment booking with ${widget.professional.name}',
        'pay_total': 100.0,
        'profile_services_data': {
          'id': widget.professional.id,
          'name': widget.professional.name,
          'avatar': widget.professional.avatar,
          'role': widget.professional.role,
          'provider_type': widget.professional.providerType,
          'experience': widget.professional.experience,
          'rating': widget.professional.rating,
          'about': widget.professional.about,
          'working_information': widget.professional.workingInformation,
          'working_hours': widget.professional.workingHours,
          'workplace': widget.professional.workplace,
          'user_id': widget.professional.userId,
        },
      };

      if (widget.appointmentId != null) {
        await _appointmentService.updateAppointment(
          widget.appointmentId!,
          appointmentData,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment rescheduled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final response =
            await _appointmentService.createAppointment(appointmentData);
        final detailData = {
          'id': response['data']?['id'] ?? 0,
          ...appointmentData,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create appointment: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final professional = widget.professional;

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
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            professional.avatar ?? '',
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
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            professional.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(professional.role),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.teal),
                              SizedBox(width: 4),
                              Text(professional.workplace ?? 'Not specified'),
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
          onPressed: _isSubmitting ? null : _submitAppointment,
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
