import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_bloc.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_event.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_state.dart';
import 'package:m2health/cubit/nursing/pages/details/nursing_add_on.dart';
import 'package:m2health/cubit/nursing/personal/nursing_personal_state.dart';
import 'package:m2health/utils.dart';

// import 'details/add_on.dart';

class NursingAddIssuePage extends StatefulWidget {
  final NursingIssue? issue;
  final String serviceType;

  NursingAddIssuePage({this.issue, required this.serviceType});

  @override
  _AddIssuePageState createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<NursingAddIssuePage> {
  late String _mobilityStatus;
  MedicalRecord? _selectedRecord;
  List<MedicalRecord> _medicalRecords = [];

  @override
  void initState() {
    super.initState();
    _mobilityStatus = 'bedbound';
    context.read<MedicalRecordBloc>().add(FetchMedicalRecords());
  }

  Future<void> _submitData() async {
    final issue = widget.issue;
    if (issue == null) return;

    print('Mobility Status: $_mobilityStatus');
    print('Related Health Record: $_selectedRecord');

    try {
      final token = await Utils.getSpString(Const.TOKEN);

      // Find the selected record and extract just its ID
      final selectedRecord =
          _medicalRecords.firstWhere((record) => record == _selectedRecord);
      final int recordId = selectedRecord.id;

      final data = {
        'mobility_status': _mobilityStatus,
        'related_health_record_id': recordId, // Submit just the ID
      };

      print('Data to be submitted: $data');

      final url = '${Const.API_PERSONAL_CASES}/${issue.id}';
      print('Request URL: $url');

      final response = await Dio().put(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Issue updated successfully');
      } else {
        print('Failed to update issue: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOn(
          issue: issue,
          serviceType: widget.serviceType, // Pass the required serviceType
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.serviceType} - Add Issue',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<MedicalRecordBloc, MedicalRecordState>(
        builder: (context, state) {
          if (state is MedicalRecordLoaded) {
            _medicalRecords = state.medicalRecords;
            if (_medicalRecords.isNotEmpty && _selectedRecord == null) {
              _selectedRecord = _medicalRecords.first;
            }
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select your mobility status',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Walk'),
                          value: 'walk',
                          groupValue: _mobilityStatus,
                          onChanged: (value) {
                            setState(() {
                              _mobilityStatus = value!;
                            });
                          },
                          activeColor: const Color(0xFF35C5CF),
                        ),
                        RadioListTile<String>(
                          title: const Text('Stand'),
                          value: 'stand',
                          groupValue: _mobilityStatus,
                          onChanged: (value) {
                            setState(() {
                              _mobilityStatus = value!;
                            });
                          },
                          activeColor: const Color(0xFF35C5CF),
                        ),
                        RadioListTile<String>(
                          title: const Text('Chair'),
                          value: 'chair',
                          groupValue: _mobilityStatus,
                          onChanged: (value) {
                            setState(() {
                              _mobilityStatus = value!;
                            });
                          },
                          activeColor: const Color(0xFF35C5CF),
                        ),
                        RadioListTile<String>(
                          title: const Text('Bed'),
                          value: 'bed',
                          groupValue: _mobilityStatus,
                          onChanged: (value) {
                            setState(() {
                              _mobilityStatus = value!;
                            });
                          },
                          activeColor: const Color(0xFF35C5CF),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select a related health record',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    if (state is MedicalRecordLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state is MedicalRecordError)
                      Text('Error: ${state.message}')
                    else if (_medicalRecords.isEmpty)
                      const Text('No medical records available')
                    else
                      Container(
                        width: 362,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<MedicalRecord>(
                            value: _selectedRecord,
                            items: _medicalRecords.map((record) {
                              return DropdownMenuItem<MedicalRecord>(
                                value: record,
                                child: Text(record.title),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedRecord = newValue!;
                              });
                            },
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            dropdownColor: Colors.white,
                          ),
                        ),
                      ),
                    const Spacer(),
                    SizedBox(
                      width: 352,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _submitData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF35C5CF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
