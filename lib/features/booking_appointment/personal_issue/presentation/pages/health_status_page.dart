import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/features/medical_record/presentation/bloc/medical_record_bloc.dart';
import 'package:m2health/features/medical_record/presentation/bloc/medical_record_event.dart';
import 'package:m2health/features/medical_record/presentation/bloc/medical_record_state.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/bloc/nursing_appointment_flow_bloc.dart';

class HealthStatusPage extends StatefulWidget {
  final Function(HealthStatus) onSubmit;
  final HealthStatus? initialHealthStatus;

  const HealthStatusPage({
    super.key,
    required this.onSubmit,
    this.initialHealthStatus,
  });

  @override
  State<HealthStatusPage> createState() => HealthStatusPageState();
}

class HealthStatusPageState extends State<HealthStatusPage> {
  late HealthStatus healthStatus;

  @override
  void initState() {
    super.initState();
    healthStatus = widget.initialHealthStatus ?? const HealthStatus();
    context.read<MedicalRecordBloc>().add(FetchMedicalRecords());
  }

  void _onClickNext(BuildContext context, HealthStatus healthStatus) {
    widget.onSubmit(healthStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Case Detail',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select your mobility status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...MobilityStatus.values.map((status) {
              return RadioListTile<MobilityStatus>(
                title: Text(status.displayName),
                value: status,
                groupValue: healthStatus.mobilityStatus,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      healthStatus =
                          healthStatus.copyWith(mobilityStatus: value);
                    });
                  }
                },
                activeColor: const Color(0xFF35C5CF),
              );
            }),
            const SizedBox(height: 20),
            const Text('Select a related health record',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10.0),
            BlocBuilder<MedicalRecordBloc, MedicalRecordState>(
              builder: (context, medicalState) {
                if (medicalState.listStatus == ListStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (medicalState.listStatus == ListStatus.failure) {
                  return Center(
                      child: Text(
                          medicalState.listError ?? 'Error loading records'));
                }
                if (medicalState.listStatus == ListStatus.success) {
                  if (medicalState.medicalRecords.isEmpty) {
                    return const Text('No medical records available.');
                  }
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: healthStatus.relatedHealthRecordId,
                        hint: const Text('Please select a record'),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('None'),
                          ),
                          ...medicalState.medicalRecords
                              .map((MedicalRecord record) {
                            return DropdownMenuItem<int?>(
                              value: record.id,
                              child: Text(record.title),
                            );
                          })
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            healthStatus = healthStatus.copyWith(
                                relatedHealthRecordId: newValue);
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  );
                }
                return const Text('Select a status');
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: () => _onClickNext(context, healthStatus),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Next',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
