import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/main.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/utils.dart';
import 'package:dio/dio.dart';
import 'package:m2health/features/nursing/pages/payment_page.dart';
import 'package:m2health/core/data/models/profile.dart';
import 'package:m2health/core/data/models/personal_case.dart';
import 'dart:convert';

class DetailAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> appointmentData;

  DetailAppointmentPage({required this.appointmentData});

  @override
  _DetailAppointmentPageState createState() => _DetailAppointmentPageState();
}

class _DetailAppointmentPageState extends State<DetailAppointmentPage> {
  bool _isExpanded = false;
  Profile? _profile;
  PersonalCase? _personalCase;
  String? _errorMessage;

  // Helper methods for safe type conversion
  int _safeIntConversion(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _safeDoubleConversion(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

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
        if (response.data is! Map<String, dynamic>) {
          throw Exception('Unexpected response format');
        }

        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> data = responseData['data'] ?? [];

        final descriptions = data
            .whereType<Map<String, dynamic>>()
            .map((item) => item['description'] as String? ?? 'No description')
            .toList();

        final addOns = data
            .whereType<Map<String, dynamic>>()
            .map((item) => item['add_on'] as String? ?? 'No add-on')
            .toList();

        setState(() {
          _personalCase = PersonalCase(
            id: 0,
            title: '',
            description: descriptions.join(', '),
            images: [],
            mobilityStatus: '',
            relatedHealthRecord: {},
            addOn: [],
            estimatedBudget: 0.0,
            userId: 0,
          );
        });
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
      if (widget.appointmentData['provider_id'] == null) {
        throw Exception('Provider ID is missing');
      }

      if (widget.appointmentData['date'] == null ||
          widget.appointmentData['date'].toString().isEmpty) {
        throw Exception('Appointment date is missing');
      }

      final token = await Utils.getSpString(Const.TOKEN);
      if (token == null) {
        throw Exception('Token is null');
      }

      final validatedData = {
        'id': _safeIntConversion(widget.appointmentData['id']),
        'user_id': _safeIntConversion(widget.appointmentData['user_id']),
        'provider_id':
            _safeIntConversion(widget.appointmentData['provider_id']),
        'provider_type':
            widget.appointmentData['provider_type']?.toString() ?? 'pharmacist',
        'type': widget.appointmentData['type']?.toString() ?? 'pharmacist',
        'status': widget.appointmentData['status']?.toString() ?? 'pending',
        'date': widget.appointmentData['date']?.toString() ?? '',
        'hour': widget.appointmentData['hour']?.toString() ?? '',
        'summary': widget.appointmentData['summary']?.toString() ?? '',
        'pay_total': _safeDoubleConversion(widget.appointmentData['pay_total']),
        'profile_services_data':
            widget.appointmentData['profile_services_data'],
      };

      final response = await Dio().post(
        Const.API_APPOINTMENT,
        data: jsonEncode(validatedData),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData != null && responseData['data'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(
                appointmentId: _safeIntConversion(responseData['data']['id']),
                profileServiceData:
                    widget.appointmentData['profile_services_data'],
              ),
            ),
          );
        } else {
          throw Exception('Invalid response data');
        }
      } else {
        throw Exception('Failed to create appointment');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create appointment: $e';
      });
      print('Error: $e');
    }
  }

  void _cancelAppointment() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      if (token == null) {
        throw Exception('Token is null');
      }

      final cancelData = {
        'id': _safeIntConversion(widget.appointmentData['id']),
        'user_id': _safeIntConversion(widget.appointmentData['user_id']),
        'provider_id':
            _safeIntConversion(widget.appointmentData['provider_id']),
        'provider_type':
            widget.appointmentData['provider_type']?.toString() ?? 'pharmacist',
        'type': widget.appointmentData['type']?.toString() ?? 'pharmacist',
        'status': 'cancelled',
        'date': widget.appointmentData['date']?.toString() ?? '',
        'hour': widget.appointmentData['hour']?.toString() ?? '',
        'summary': widget.appointmentData['summary']?.toString() ?? '',
        'pay_total': _safeDoubleConversion(widget.appointmentData['pay_total']),
        'profile_services_data':
            widget.appointmentData['profile_services_data'],
      };

      final response = await Dio().post(
        Const.API_APPOINTMENT,
        data: jsonEncode(cancelData),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData != null && responseData['data'] != null) {
          _navigateToAppointmentPage();
        } else {
          throw Exception('Invalid response data');
        }
      } else {
        throw Exception('Failed to cancel appointment');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to cancel appointment: $e';
      });
      print('Error: $e');
    }
  }

  void _navigateToAppointmentPage() {
    context.go(AppRoutes.home);
    MyApp.showBottomAppBar(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileServicesData = widget.appointmentData['profile_services_data'];
    Map<String, dynamic> profile;

    if (profileServicesData is Map<String, dynamic>) {
      profile = profileServicesData;
    } else if (profileServicesData is String) {
      try {
        profile = jsonDecode(profileServicesData) as Map<String, dynamic>;
      } catch (e) {
        profile = {};
      }
    } else {
      profile = {};
    }

    final addOnServices =
        _personalCase?.addOn.map((e) => e.toString()).join(', ') ??
            'No additional services selected';
    final serviceCost = 10;
    final totalCost = serviceCost;

    final String profileName =
        profile['name']?.toString() ?? 'Unknown Provider';
    final String profileAvatar = profile['avatar']?.toString() ?? '';
    final String profileLocation =
        profile['maps_location']?.toString() ?? 'Location not available';
    final String appointmentStatus =
        widget.appointmentData['status']?.toString() ?? 'pending';
    final String appointmentDate =
        widget.appointmentData['date']?.toString() ?? '';
    final String appointmentHour =
        widget.appointmentData['hour']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(profileName),
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
                        color: Colors.grey[300],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: profileAvatar.isNotEmpty &&
                                !profileAvatar.contains('file:///')
                            ? Image.network(
                                profileAvatar,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/images_budi.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 25,
                                  color: Colors.grey[600],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profileName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.blue),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  profileLocation,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
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
                              appointmentStatus,
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
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
                  _formatDate(appointmentDate),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8),
                Text(appointmentHour),
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
                    Container(
                      width: 100,
                      child: const Text('Full Name: '),
                    ),
                    Flexible(
                      child: Text(_profile?.name ?? 'Unknown'),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      child: const Text('Age: '),
                    ),
                    Flexible(
                      child: Text(_profile?.age.toString() ?? '0'),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      child: const Text('Gender: '),
                    ),
                    Flexible(
                      child: Text(_profile?.gender ?? 'Not specified'),
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
                        Container(
                          width: 100,
                          child: const Text('Problem: '),
                        ),
                        Flexible(
                          child: Text(
                            _isExpanded
                                ? '${_personalCase?.description ?? 'No description available'} '
                                : '${_personalCase?.description ?? 'No description available'} ',
                          ),
                        ),
                      ],
                    ),
                    if (!_isExpanded &&
                        _personalCase != null &&
                        _personalCase!.description.isNotEmpty)
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
                    Container(
                      width: 100,
                      child: const Text('Address: '),
                    ),
                    Flexible(
                      child: Text(
                          _profile?.homeAddress ?? 'Address not available'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Loading patient information...',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Card(
              child: Container(
                height: 200,
                child: const Center(
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
              style: TextStyle(fontSize: 16),
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
                    SizedBox(width: 8),
                    Text(addOnServices),
                    Spacer(),
                    Text('\$$serviceCost'),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.attach_money, color: Colors.green),
                    Text(
                      '\$$totalCost',
                      style: TextStyle(
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
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitAppointment,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            const Icon(Icons.warning_outlined,
                                size: 50, color: Colors.red),
                            const SizedBox(height: 16),
                            const Text(
                              'Are you sure want to cancel this appointment?',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You can rebook it later from the canceled appointment menu.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _cancelAppointment();
                                  },
                                  child: const Text('Yes, Cancel'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
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

String _formatDate(String? date) {
  if (date == null || date.isEmpty) {
    return 'Date not specified';
  }

  try {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('EEEE, dd MMMM yyyy').format(parsedDate);
  } catch (e) {
    print('Error parsing date: $e');
    return 'Invalid Date';
  }
}
