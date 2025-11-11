import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/features/diabetes/widgets/diabetes_form_widget.dart';

class PhysicalSignsFormPage extends StatefulWidget {
  final PhysicalSigns initialData;
  final ValueChanged<PhysicalSigns> onChange;
  final VoidCallback onSave;
  final String saveButtonText;
  final VoidCallback? onPressBack;

  const PhysicalSignsFormPage({
    super.key,
    required this.initialData,
    required this.onChange,
    required this.onSave,
    this.saveButtonText = 'Save',
    this.onPressBack,
  });

  @override
  State<PhysicalSignsFormPage> createState() => PhysicalSignsPageState();
}

class PhysicalSignsPageState extends State<PhysicalSignsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _eyesExamDateController = TextEditingController();
  final _eyesFindingsController = TextEditingController();
  final _kidneyEgfrController = TextEditingController();
  final _kidneyAcrController = TextEditingController();

  late PhysicalSigns _currentData;

  bool validate() {
    return _formKey.currentState?.validate() ?? true;
  }

  @override
  void initState() {
    super.initState();
    _currentData = widget.initialData;
    _initializeControllers();
  }

  void _initializeControllers() {
    _eyesExamDateController.text = _currentData.eyesLastExamDate ?? '';
    _eyesFindingsController.text = _currentData.eyesFindings ?? '';
    _kidneyEgfrController.text = _currentData.kidneysEgfr ?? '';
    _kidneyAcrController.text = _currentData.kidneysUrineAcr ?? '';
    // Radio buttons (feetSkinStatus, feetDeformityStatus) are handled directly in _currentData
  }

  @override
  void dispose() {
    _eyesExamDateController.dispose();
    _eyesFindingsController.dispose();
    _kidneyEgfrController.dispose();
    _kidneyAcrController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {
      _currentData = _currentData.copyWith(
        eyesLastExamDate: _eyesExamDateController.text,
        eyesFindings: _eyesFindingsController.text,
        kidneysEgfr: _kidneyEgfrController.text,
        kidneysUrineAcr: _kidneyAcrController.text,
      );
    });
    widget.onChange(_currentData);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;
    try {
      initialDate =
          DateFormat('yyyy-MM-dd').parse(_eyesExamDateController.text);
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      _eyesExamDateController.text = formattedDate;
      _updateState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Physical Sign",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onPressBack ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormSectionHeader('Physical Signs (If Have)'),
              const FormSubHeader('Eyes:',
                  iconPath: "assets/icons/ic_eyes.png"),
              TextFormField(
                controller: _eyesExamDateController,
                onChanged: (_) => _updateState(),
                decoration: const FormInputDecoration().copyWith(
                  labelText: 'Last Exam Date',
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // This field is optional
                  }

                  // Check YYYY-MM-DD format
                  final RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!dateRegex.hasMatch(value)) {
                    return 'Invalid format (Use YYYY-MM-DD)';
                  }

                  try {
                    DateFormat('yyyy-MM-dd').parseStrict(value);
                    return null;
                  } catch (e) {
                    return 'Invalid date (e.g., month or day is out of range).';
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _eyesFindingsController,
                onChanged: (_) => _updateState(),
                decoration:
                    const FormInputDecoration().copyWith(labelText: 'Findings'),
              ),
              const SizedBox(height: 24),
              const FormSubHeader('Kidneys:',
                  iconPath: "assets/icons/ic_kidney.png"),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _kidneyEgfrController,
                      onChanged: (_) => _updateState(),
                      decoration: const FormInputDecoration()
                          .copyWith(labelText: 'eGFR', hintText: 'E.g 90'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _kidneyAcrController,
                      onChanged: (_) => _updateState(),
                      decoration: const FormInputDecoration().copyWith(
                          labelText: 'Urine ACR', hintText: 'E.g 30 mg/g'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const FormSubHeader('Feet:',
                  iconPath: "assets/icons/ic_feet.png"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _FeetSection(
                      title: 'Skin:',
                      options: const ['Normal', 'Dry', 'Ulcer', 'Infection'],
                      groupValue: _currentData.feetSkinStatus,
                      onChanged: (v) {
                        final newData =
                            _currentData.copyWith(feetSkinStatus: v);
                        setState(() => _currentData = newData);
                        widget.onChange(newData);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _FeetSection(
                      title: 'Deformity:',
                      options: const ['None', 'Bunions', 'Claw toes'],
                      groupValue: _currentData.feetDeformityStatus,
                      onChanged: (v) {
                        final newData =
                            _currentData.copyWith(feetDeformityStatus: v);
                        setState(() => _currentData = newData);
                        widget.onChange(newData);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: widget.saveButtonText,
          onPressed: () {
            if (validate()) {
              // Optional fields don't block saving
              widget.onSave();
            }
          },
        ),
      ),
    );
  }
}

/// A specialized widget for the "Feet" section with radio buttons.
class _FeetSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const _FeetSection({
    required this.title,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSubHeader(title),
        ...options.map((option) {
          return Row(
            children: [
              Radio<String>(
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: primaryColor,
              ),
              Expanded(child: Text(option)),
            ],
          );
        }),
      ],
    );
  }
}
