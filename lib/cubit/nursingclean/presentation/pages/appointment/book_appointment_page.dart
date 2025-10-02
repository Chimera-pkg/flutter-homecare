import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/professional_entity.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_appointment_form/nursing_appointment_form_bloc.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_bloc.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_state.dart';
import 'package:m2health/cubit/nursingclean/presentation/pages/appointment/review_appointment_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:m2health/widgets/time_slot_grid_view.dart';

class BookAppointmentPage extends StatefulWidget {
  final ProfessionalEntity professional;

  const BookAppointmentPage({
    Key? key,
    required this.professional,
  }) : super(key: key);

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  DateTime? selectTime;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  void _submitAppointment() {
    if (selectTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot first.')),
      );
      return;
    }

    final nursingCaseState = context.read<NursingCaseBloc>().state;
    if (nursingCaseState is! NursingCaseLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nursing case details are not ready.')),
      );
      return;
    }
    context.read<NursingAppointmentFormBloc>().add(
          NursingAppointmentSubmitted(
            professional: widget.professional,
            selectedDate: _selectedDay,
            selectedTime: selectTime!,
            nursingCase: nursingCaseState.nursingCase,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NursingAppointmentFormBloc,
        NursingAppointmentFormState>(
      listener: (context, state) {
        if (state is NursingAppointmentFormSubmissionSuccess) {
          debugPrint('Appointment booked successfully');
          debugPrint('Appointment Details: ${state.appointment}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewAppointmentPage(
                appointment: state.appointment,
                nursingCase: state.nursingCase,
                professional: widget.professional,
              ),
            ),
          );
        } else if (state is NursingAppointmentFormSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to book appointment: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child:
          BlocBuilder<NursingAppointmentFormBloc, NursingAppointmentFormState>(
        builder: (context, state) {
          final isSubmitting =
              state is NursingAppointmentFormSubmissionInProgress;

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
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomButton(isSubmitting),
          );
        },
      ),
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
                  professional.avatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/images_budi.png', // Placeholder image
                      fit: BoxFit.cover,
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
                          professional.mapsLocation,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
    );
  }

  Widget _buildBottomButton(bool isSubmitting) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : _submitAppointment,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isSubmitting
                ? const Color(0xFF35C5CF).withOpacity(0.6)
                : const Color(0xFF35C5CF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: isSubmitting
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Submitting...',
                        style: TextStyle(color: Colors.white)),
                  ],
                )
              : const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
