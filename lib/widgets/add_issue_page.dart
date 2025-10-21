import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/medical_record/data/model/medical_record_model.dart';
import 'package:m2health/cubit/personal/personal_cubit.dart';
import 'package:m2health/cubit/personal/personal_state.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/views/details/add_on.dart';

enum MobilityStatus {
  bed('bed', 'Bedbound'),
  wheelchair('wheelchair', 'Wheelchair Bound'),
  stand('stand', 'Walking Aid'),
  walk('walk', 'Mobile Without Aid');

  const MobilityStatus(this.value, this.label);

  final String label;
  final String value;

  static MobilityStatus fromValue(String? value) {
    return MobilityStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => MobilityStatus.walk,
    );
  }
}

class AddIssuePage extends StatefulWidget {
  final Issue? issue;
  final String serviceType;

  const AddIssuePage({super.key, this.issue, required this.serviceType});

  @override
  State<AddIssuePage> createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  late MobilityStatus _mobilityStatus;
  MedicalRecord? _selectedRecord; // Changed from String
  List<MedicalRecord> _medicalRecords = []; // Changed from List<Map>
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mobilityStatus = MobilityStatus.fromValue(widget.issue?.mobilityStatus);
    _fetchMedicalRecords();
  }

  Future<void> _fetchMedicalRecords() async {
    try {
      setState(() {
        isLoading = true;
      });

      final token = await Utils.getSpString(Const.TOKEN);
      final response = await Dio().get(
        Const.API_MEDICAL_RECORDS,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        setState(() {
          _medicalRecords =
              data.map((json) => MedicalRecordModel.fromJson(json)).toList();
          if (_medicalRecords.isNotEmpty) {
            _selectedRecord = _medicalRecords.first;
          }
        });
      } else {
        throw Exception('Failed to fetch medical records');
      }
    } catch (e) {
      log('Error fetching medical records: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _submitData() {
    final issue = widget.issue;
    if (issue == null) return;

    final updatedIssue = issue.copyWith(
      mobilityStatus: _mobilityStatus.value,
      relatedHealthRecord: _selectedRecord,
    );

    context.read<PersonalCubit>().updateIssue(updatedIssue);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOn(
          issue: updatedIssue,
          serviceType: widget.serviceType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request ${widget.serviceType} Services',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select your mobility status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: MobilityStatus.values.map((status) {
                    return RadioListTile<MobilityStatus>(
                      title: Text(status.label),
                      value: status,
                      groupValue: _mobilityStatus,
                      onChanged: (MobilityStatus? value) {
                        setState(() {
                          _mobilityStatus = value!;
                        });
                      },
                      activeColor: const Color(0xFF35C5CF),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select a related health record',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                if (_medicalRecords.isEmpty)
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
                        hint: const Text("Select Status"),
                        isExpanded: true,
                        items: _medicalRecords.map((record) {
                          return DropdownMenuItem<MedicalRecord>(
                            value: record, // The value is the object itself
                            child: Text(record.title),
                          );
                        }).toList(),
                        onChanged: (MedicalRecord? newValue) {
                          setState(() {
                            _selectedRecord = newValue;
                          });
                        },
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
                const SizedBox(height: 20),
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
          if (isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
