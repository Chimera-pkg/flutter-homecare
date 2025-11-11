import 'package:flutter/material.dart';

class DetailAppointmentPage extends StatelessWidget {
  final Map<String, dynamic> appointmentData;

  const DetailAppointmentPage({
    super.key,
    required this.appointmentData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appointment ID: ${appointmentData['id']}'),
            Text('Status: ${appointmentData['status']}'),
            Text('Date: ${appointmentData['date']}'),
            Text('Time: ${appointmentData['hour']}'),
            Text('Summary: ${appointmentData['summary']}'),
            Text('Total: ${appointmentData['pay_total']}'),
          ],
        ),
      ),
    );
  }
}
