import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_bloc.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_event.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_state.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/mobility_status.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_bloc.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_state.dart';
import 'package:m2health/cubit/nursingclean/presentation/pages/nursing_case/nursing_addon_page.dart';

class NursingHealthStatusPage extends StatefulWidget {
  const NursingHealthStatusPage({super.key});

  @override
  _NursingHealthStatusPageState createState() =>
      _NursingHealthStatusPageState();
}

class _NursingHealthStatusPageState extends State<NursingHealthStatusPage> {
  void _onClickNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NursingAddOnPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<MedicalRecordBloc>().add(FetchMedicalRecords());
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
      body: BlocBuilder<NursingCaseBloc, NursingCaseState>(
        builder: (context, nursingState) {
          if (nursingState is! NursingCaseLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final nursingCase = nursingState.nursingCase;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select your mobility status',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ...MobilityStatus.values.map((status) {
                  return RadioListTile<MobilityStatus>(
                    title: Text(status.displayName),
                    value: status,
                    groupValue: nursingCase.mobilityStatus,
                    onChanged: (value) {
                      if (value != null) {
                        context
                            .read<NursingCaseBloc>()
                            .add(UpdateHealthStatusNursingCaseEvent(
                              mobilityStatus: value,
                              relatedHealthRecordId:
                                  nursingCase.relatedHealthRecordId,
                            ));
                      }
                    },
                    activeColor: const Color(0xFF35C5CF),
                  );
                }),
                const SizedBox(height: 20),
                const Text('Select a related health record',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                BlocBuilder<MedicalRecordBloc, MedicalRecordState>(
                  builder: (context, medicalState) {
                    if (medicalState.listStatus == ListStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (medicalState.listStatus == ListStatus.failure) {
                      return Center(child: Text(medicalState.listError ?? 'Error loading records'));
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
                            value: nursingCase.relatedHealthRecordId,
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
                              context
                                  .read<NursingCaseBloc>()
                                  .add(UpdateHealthStatusNursingCaseEvent(
                                    mobilityStatus: nursingCase.mobilityStatus,
                                    relatedHealthRecordId: newValue,
                                  ));
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
                    onPressed: _onClickNext,
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
          );
        },
      ),
    );
  }
}
