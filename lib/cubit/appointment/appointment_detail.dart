import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/appointment/appointment_cubit.dart';
import 'package:m2health/cubit/appointment/widgets/cancel_appoinment_dialog.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';
import 'package:dio/dio.dart';
import 'package:m2health/views/payment.dart';
import 'package:m2health/models/profile.dart';
import 'package:m2health/models/personal_case.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class DetailAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> appointmentData;

  const DetailAppointmentPage({super.key, required this.appointmentData});

  @override
  State<DetailAppointmentPage> createState() => _DetailAppointmentPageState();
}

class _DetailAppointmentPageState extends State<DetailAppointmentPage> {
  bool _isExpanded = false;
  Profile? _profile;
  PersonalCase? _personalCase;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchPersonalCase();
  }

  Future<void> _fetchProfile() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await Dio().get(
        '${Const.URL_API}/profiles',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final profileData = response.data['data'];
        if (profileData is Map<String, dynamic>) {
          final profile = Profile.fromJson(profileData);
          setState(() {
            _profile = profile;
          });
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: $e';
      });
      print('Error: $e');
    }
  }

  Future<void> _fetchPersonalCase() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await Dio().get(
        Const.API_PERSONAL_CASES,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Ensure response.data is a Map before accessing 'data'
        if (response.data is! Map<String, dynamic>) {
          throw Exception('Unexpected response format');
        }

        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> data =
            responseData['data'] ?? []; // Handle missing 'data' key safely

        final descriptions = data
            .whereType<Map<String, dynamic>>() // Ensure every item is a map
            .map((item) =>
                item['description'] as String? ??
                'No description') // Handle null safely
            .toList();

        final addOns = data
            .whereType<Map<String, dynamic>>() // Ensure every item is a map
            .map((item) =>
                item['add_on'] as String? ?? 'No add-on') // Handle null safely
            .toList();

        setState(() {
          _personalCase = PersonalCase(
            id: 0,
            title: '',
            description: descriptions.join(', '),
            images: [],
            mobilityStatus: '',
            relatedHealthRecord: {},
            addOn: addOns.isNotEmpty ? addOns.last : '',
            estimatedBudget: 0.0,
            userId: 0,
          );
        });

        print('Personal case data: ${descriptions.join(', ')}');
      } else {
        throw Exception('Failed to load personal case: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load personal case: $e';
      });
      print('Error: $e');
    }
  }

  Future<void> _submitAppointment() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      if (token == null) {
        throw Exception('Token is null');
      }

      // Print the data being submitted
      print('Data being submitted: ${jsonEncode(widget.appointmentData)}');

      final response = await Dio().post(
        Const.API_APPOINTMENT,
        data: jsonEncode(widget.appointmentData), // Convert to JSON string
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json', // Set content type to JSON
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData != null && responseData['data'] != null) {
          // Handle successful submission
          print('Appointment created successfully');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(
                appointmentId: responseData['data']['id'],
                profileServiceData:
                    widget.appointmentData['profile_services_data'],
              ),
            ),
          );
        } else {
          throw Exception('Invalid response data');
        }
      } else {
        print('Error: ${response.statusCode} - ${response.statusMessage}');
        throw Exception('Failed to create appointment');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create appointment: $e';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.appointmentData['profile_services_data'];
    final addOnServices = _personalCase?.addOn ?? '';
    final serviceCost = 10; // Dummy cost for each service
    final totalCost =
        serviceCost; // Since add_on is a single string, total cost is serviceCost

    return Scaffold(
      appBar: AppBar(
        title: Text(profile['name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Card(
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
                          image: NetworkImage(profile['avatar']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(profile['maps_location']),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.yellow),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.appointmentData['status'],
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Schedule Appointment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  _formatDate(
                      widget.appointmentData['date']), // Use the formatted date
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8),
                Text(widget.appointmentData['hour']),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Patient Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            if (_profile != null) ...[
              ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 100, // Set a fixed width for the label
                      child: Text('Full Name: '),
                    ),
                    Flexible(
                      child: Text(_profile!.username),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 100, // Set a fixed width for the label
                      child: Text('Age: '),
                    ),
                    Flexible(
                      child: Text(_profile!.age.toString()),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 100, // Set a fixed width for the label
                      child: Text('Gender: '),
                    ),
                    Flexible(
                      child: Text(_profile!.gender),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 100, // Set a fixed width for the label
                          child: Text('Problem: '),
                        ),
                        Flexible(
                          child: Text(
                            _isExpanded
                                ? '${_personalCase?.description ?? ''} '
                                : '${_personalCase?.description ?? ''} ',
                          ),
                        ),
                      ],
                    ),
                    if (!_isExpanded)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = true;
                          });
                        },
                        child: const Text(
                          'View More',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 100, // Set a fixed width for the label
                      child: Text('Address: '),
                    ),
                    Flexible(
                      child: Text(_profile!.homeAddress),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Card(
              child: SizedBox(
                height: 200,
                child: Center(
                  child: Text('Google Map Placeholder'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Services',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              addOnServices,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text(
                  'Estimated Budget',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline_rounded, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(addOnServices),
                    const Spacer(),
                    Text('\$$serviceCost'),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.attach_money, color: Colors.green),
                    Text(
                      '\$$totalCost',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity, // Set the width to fill the parent
              height: 50, // Set a fixed height
              child: ElevatedButton(
                onPressed: _submitAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity, // Set the width to fill the parent
              height: 50, // Set a fixed height
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CancelAppoinmentDialog(onPressYes: () {
                        context
                            .read<AppointmentCubit>()
                            .cancelAppointment(widget.appointmentData['id']);
                        GoRouter.of(context).go(AppRoutes.appointment);
                      });
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // Set the background color to red
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(String date) {
  try {
    final DateTime parsedDate = DateTime.parse(date); // Parse the date string
    return DateFormat('EEEE, dd MMMM yyyy')
        .format(parsedDate); // Format as "Day, Date"
  } catch (e) {
    print('Error parsing date: $e');
    return 'Invalid Date'; // Fallback in case of an error
  }
}
