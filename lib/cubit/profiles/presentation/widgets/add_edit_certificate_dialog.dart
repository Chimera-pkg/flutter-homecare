import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/profiles/domain/entities/certificate.dart';
import 'dart:io';

import 'package:m2health/widgets/image_preview.dart';

class AddEditCertificateDialog extends StatefulWidget {
  final Certificate? certification;
  final Function(String title, String regNum, String issuedOn, File file)
      onSave;

  const AddEditCertificateDialog({
    super.key,
    this.certification,
    required this.onSave,
  });

  @override
  _AddEditCertificateDialogState createState() =>
      _AddEditCertificateDialogState();
}

class _AddEditCertificateDialogState
    extends State<AddEditCertificateDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _registrationNumberController;
  late TextEditingController _issuedOnController;
  File? _selectedFile;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.certification?.title ?? '');
    _registrationNumberController = TextEditingController(
        text: widget.certification?.registrationNumber ?? '');
    _issuedOnController =
        TextEditingController(text: widget.certification?.issuedOn ?? '');
    if (widget.certification?.fileURL != null &&
        widget.certification!.fileURL.isNotEmpty) {
      _fileName = 'Existing File';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _registrationNumberController.dispose();
    _issuedOnController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(_issuedOnController.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Const.aqua,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Const.aqua,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _issuedOnController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null && widget.certification == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select a file."),
          backgroundColor: Colors.red,
        ));
        return;
      }

      widget.onSave(
        _titleController.text,
        _registrationNumberController.text,
        _issuedOnController.text,
        _selectedFile ?? File('dummy.pdf'),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.certification == null
            ? 'Add New Certificate'
            : 'Edit Certificate',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Const.aqua,
        ),
      ),
      backgroundColor: Colors.white,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Certificate Title",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: _titleController,
                decoration: const InputDecoration(
                    hintText: 'E.g: International Standard Nursing'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                "Professional Registration Number",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: _registrationNumberController,
                decoration: const InputDecoration(hintText: 'E.g: GOV98919XV '),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a number' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                "Issued on",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              TextFormField(
                controller: _issuedOnController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  hintText: 'Issued On',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an issue date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ImagePreview(
                  helperText: "Certificate (less than 10 MB)",
                  onChooseImage: (File? file) {
                    setState(() {
                      _selectedFile = file;
                    });
                  }),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Discard'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: Const.aqua,
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
