import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_bloc.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_event.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_state.dart';
import 'package:m2health/cubit/medical_record/presentation/pages/medical_record_detail.dart';
import 'package:m2health/cubit/medical_record/presentation/pages/medical_record_form_page.dart';

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MedicalRecordBloc>().add(FetchMedicalRecords());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Medical Records',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: BlocListener<MedicalRecordBloc, MedicalRecordState>(
        listenWhen: (previous, current) =>
            previous.deleteStatus != current.deleteStatus,
        listener: (context, state) {
          if (state.deleteStatus == DeleteStatus.loading) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Deleting...')));
          } else if (state.deleteStatus == DeleteStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('Record deleted successfully'),
                  backgroundColor: Colors.green));
          } else if (state.deleteStatus == DeleteStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(state.deleteError ?? 'Failed to delete'),
                  backgroundColor: Colors.red));
          }
        },
        child: BlocBuilder<MedicalRecordBloc, MedicalRecordState>(
          buildWhen: (previous, current) =>
              previous.listStatus != current.listStatus ||
              previous.medicalRecords != current.medicalRecords,
          builder: (context, state) {
            if (state.listStatus == ListStatus.loading ||
                state.listStatus == ListStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.listStatus == ListStatus.failure) {
              return Center(
                  child: Text(state.listError ?? 'Failed to load records.'));
            }

            if (state.medicalRecords.isEmpty) {
              return const Center(
                child: Text(
                  'No medical records found.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.medicalRecords.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final record = state.medicalRecords[index];
                return _MedicalRecordCard(record: record);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Const.aqua,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const MedicalRecordFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MedicalRecordCard extends StatelessWidget {
  final MedicalRecord record;

  const _MedicalRecordCard({required this.record});

  void _showDeleteDialog(BuildContext context, MedicalRecord record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to remove this record?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
            onPressed: () {
              context
                  .read<MedicalRecordBloc>()
                  .add(DeleteMedicalRecordEvent(record));
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        // side: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        title: Text(
          record.title, //
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Last updated: ${DateFormat('dd-MM-yyyy').format(record.updatedAt)}', //
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        // The three-dot menu
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          color: Colors.white,
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MedicalRecordFormPage(recordToEdit: record),
                ),
              );
            } else if (value == 'delete') {
              _showDeleteDialog(context, record);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Modify'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Remove'),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MedicalRecordDetailPage(record: record),
            ),
          );
        },
      ),
    );
  }
}
