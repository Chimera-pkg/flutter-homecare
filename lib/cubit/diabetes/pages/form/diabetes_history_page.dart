import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/cubit/diabetes/widgets/diabetes_form_widget.dart';

class DiabetesHistoryFormPage extends StatefulWidget {
  final DiabetesHistory initialData;
  final ValueChanged<DiabetesHistory> onChange;
  final VoidCallback onSave;
  final String saveButtonText;
  final VoidCallback? onPressBack;

  const DiabetesHistoryFormPage({
    super.key,
    required this.initialData,
    required this.onChange,
    required this.onSave,
    this.saveButtonText = 'Save',
    this.onPressBack,
  });

  @override
  State<DiabetesHistoryFormPage> createState() => DiabetesHistoryPageState();
}

class DiabetesHistoryPageState extends State<DiabetesHistoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _otherDiabetesTypeController = TextEditingController();
  final _yearDiagnosisController = TextEditingController();
  final _lastHbA1cController = TextEditingController();
  final _oralMedicationsController = TextEditingController();
  final _insulinTypeDoseController = TextEditingController();

  static const List<String> _predefinedDiabetesTypes = [
    'Type 1',
    'Type 2',
    'Gestational'
  ];
  String? _selectedRadioOption;
  late DiabetesHistory _currentData;

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
    _yearDiagnosisController.text =
        _currentData.yearOfDiagnosis?.toString() ?? '';
    _lastHbA1cController.text = _currentData.lastHbA1c?.toString() ?? '';
    _oralMedicationsController.text = _currentData.oralMedication ?? '';
    _insulinTypeDoseController.text = _currentData.insulinTypeDose ?? '';

    if (_currentData.diabetesType != null) {
      if (_predefinedDiabetesTypes.contains(_currentData.diabetesType)) {
        _selectedRadioOption = _currentData.diabetesType;
      } else {
        _selectedRadioOption = 'Other';
        _otherDiabetesTypeController.text = _currentData.diabetesType!;
      }
    }
  }

  @override
  void dispose() {
    _otherDiabetesTypeController.dispose();
    _yearDiagnosisController.dispose();
    _lastHbA1cController.dispose();
    _oralMedicationsController.dispose();
    _insulinTypeDoseController.dispose();
    super.dispose();
  }

  void _updateStateAndNotify() {
    String? newDiabetesType;
    if (_selectedRadioOption == 'Other') {
      newDiabetesType = _otherDiabetesTypeController.text;
    } else {
      newDiabetesType = _selectedRadioOption;
    }

    _currentData = _currentData.copyWith(
      diabetesType: newDiabetesType,
      yearOfDiagnosis: int.tryParse(_yearDiagnosisController.text),
      lastHbA1c: double.tryParse(_lastHbA1cController.text),
      oralMedication: _oralMedicationsController.text,
      insulinTypeDose: _insulinTypeDoseController.text,
    );
    widget.onChange(_currentData);
  }

  @override
  Widget build(BuildContext context) {
    const diabetesRadioOptions = [..._predefinedDiabetesTypes, 'Other'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Diabetes History",
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
              const FormSectionHeader('Diabetes History'),
              const FormSubHeader('Type of Diabetes:',
                  iconPath: "assets/icons/ic_diabetes_type.png"),
              FormField<String>(
                builder: (FormFieldState<String> field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10.0,
                        runSpacing: -4.0,
                        children: diabetesRadioOptions.map((type) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: type,
                                activeColor: primaryColor,
                                groupValue: _selectedRadioOption,
                                onChanged: (v) {
                                  setState(() {
                                    _selectedRadioOption = v;
                                  });
                                  if (v != 'Other') {
                                    _otherDiabetesTypeController.clear();
                                  }
                                  _updateStateAndNotify();
                                  field.didChange(v);
                                },
                              ),
                              Text(type),
                            ],
                          );
                        }).toList(),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 5.0),
                          child: Text(
                            field.errorText!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12),
                          ),
                        ),
                    ],
                  );
                },
                validator: (value) {
                  if (_selectedRadioOption == null) {
                    return 'Please select an option.';
                  }
                  return null;
                },
              ),
              if (_selectedRadioOption == 'Other') ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextFormField(
                    controller: _otherDiabetesTypeController,
                    onChanged: (_) => _updateStateAndNotify(),
                    decoration: const FormInputDecoration().copyWith(
                        hintText: 'Please enter your type of diabetes'),
                    validator: (value) {
                      if (_selectedRadioOption != 'Other') return null;
                      if (_otherDiabetesTypeController.text.trim().isEmpty) {
                        return 'Please specify your type of diabetes.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FormSubHeader('Year of Diagnosis:',
                            iconPath: "assets/icons/ic_calendar.png"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _yearDiagnosisController,
                          onChanged: (_) => _updateStateAndNotify(),
                          decoration: const FormInputDecoration()
                              .copyWith(hintText: 'e.g 2021'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null; // Not required, so no error if empty
                            }
                            if (value.length != 4 ||
                                int.tryParse(value) == null ||
                                int.parse(value) > DateTime.now().year) {
                              return 'Invalid year.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FormSubHeader('Last HbA1c:',
                            iconPath: "assets/icons/ic_blood_measurement.png"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _lastHbA1cController,
                          onChanged: (_) => _updateStateAndNotify(),
                          decoration: const FormInputDecoration()
                              .copyWith(hintText: "5.0", suffixText: '%'),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null; // Not required
                            }
                            final hba1c = double.tryParse(value);
                            if (hba1c == null || hba1c < 0 || hba1c > 100) {
                              return 'Invalid value.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const FormSubHeader('Current Treatment:',
                  iconPath: "assets/icons/ic_medical_checklist.png"),
              FormCheckbox(
                title: 'Diet & Exercise',
                value: _currentData.hasTreatmentDiet,
                onChanged: (v) {
                  setState(() {
                    _currentData = _currentData.copyWith(hasTreatmentDiet: v);
                  });
                  _updateStateAndNotify();
                },
              ),
              FormCheckbox(
                title: 'Oral Medications',
                value: _currentData.hasTreatmentOral,
                onChanged: (v) {
                  setState(() {
                    _currentData = _currentData.copyWith(hasTreatmentOral: v);
                  });
                  _updateStateAndNotify();
                },
              ),
              if (_currentData.hasTreatmentOral)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 8, top: 8, bottom: 8),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _oralMedicationsController,
                    onChanged: (_) => _updateStateAndNotify(),
                    decoration: const FormInputDecoration()
                        .copyWith(hintText: 'List medications...'),
                    validator: (value) {
                      if (!_currentData.hasTreatmentOral) return null;
                      if (value == null || value.isEmpty) {
                        return 'Please list your oral medications.';
                      }
                      return null;
                    },
                  ),
                ),
              FormCheckbox(
                title: 'Insulin',
                value: _currentData.hasTreatmentInsulin,
                onChanged: (v) {
                  setState(() {
                    _currentData =
                        _currentData.copyWith(hasTreatmentInsulin: v);
                  });
                  _updateStateAndNotify();
                },
              ),
              if (_currentData.hasTreatmentInsulin)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 8, top: 8, bottom: 8),
                  child: TextFormField(
                    controller: _insulinTypeDoseController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (_) => _updateStateAndNotify(),
                    decoration: const FormInputDecoration()
                        .copyWith(hintText: 'Type & dose'),
                    validator: (value) {
                      if (!_currentData.hasTreatmentInsulin) return null;
                      if (value == null || value.isEmpty) {
                        return 'Please specify your insulin type & dose.';
                      }
                      return null;
                    },
                  ),
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
              widget.onSave();
            }
          },
        ),
      ),
    );
  }
}
