import 'package:flutter/material.dart';

// Untuk menjalankan file ini secara mandiri
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Form',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        scaffoldBackgroundColor:
            const Color(0xFFF5F5F5), // Background abu-abu muda
        fontFamily: 'Roboto', // Ganti dengan font yang Anda inginkan
      ),
      home: const DiabetesFormPage(),
    );
  }
}

class DiabetesFormPage extends StatefulWidget {
  const DiabetesFormPage({super.key});

  @override
  State<DiabetesFormPage> createState() => _DiabetesFormPageState();
}

class _DiabetesFormPageState extends State<DiabetesFormPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // State Halaman 1
  String? diabetesType;
  final TextEditingController otherDiabetesTypeController =
      TextEditingController();
  final TextEditingController yearDiagnosisController = TextEditingController();
  final TextEditingController lastHbA1cController = TextEditingController();
  bool treatmentDiet = false;
  bool treatmentOral = false;
  bool treatmentInsulin = false;
  final TextEditingController oralMedicationsController =
      TextEditingController();
  final TextEditingController insulinTypeDoseController =
      TextEditingController();

  // State Halaman 2
  final List<String> riskFactorItems = [
    'Hypertension',
    'Dyslipidemia',
    'Cardiovascular\nDisease',
    'Neuropathy',
    'Eye Disease\n(Retinopathy)',
    'Kidney Disease',
    'Family History\nof Diabetes',
  ];
  Map<String, String?> riskFactors = {};
  String? smokingStatus;

  // State Halaman 3
  String? hypoglycemia;
  String? physicalActivity;
  String? dietQuality;

  // State Halaman 4
  final TextEditingController eyesExamDateController = TextEditingController();
  final TextEditingController eyesFindingsController = TextEditingController();
  final TextEditingController kidneyEgfrController = TextEditingController();
  final TextEditingController kidneyAcrController = TextEditingController();
  String? feetSkin;
  String? feetDeformity;

  // Styling Constants
  final Color primaryColor = const Color(0xFF26C6DA);
  final Color inactiveColor = Colors.grey.shade400;
  final Color textColor = Colors.black87;

  @override
  void dispose() {
    _pageController.dispose();
    otherDiabetesTypeController.dispose();
    yearDiagnosisController.dispose();
    lastHbA1cController.dispose();
    oralMedicationsController.dispose();
    insulinTypeDoseController.dispose();
    eyesExamDateController.dispose();
    eyesFindingsController.dispose();
    kidneyEgfrController.dispose();
    kidneyAcrController.dispose();
    super.dispose();
  }

  // --- Navigasi & Submit ---
  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted! Check console for data.')),
    );
  }

  // --- Widget Builders ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
      ),
    );
  }

  Widget _buildSubHeader(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.red.shade400, size: 20),
            const SizedBox(width: 8)
          ],
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: textColor.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  // --- HALAMAN 1: Diabetes History (PERBAIKAN TOTAL SESUAI DESAIN BARU) ---
  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Utama Section
          _buildSectionHeader('Diabetes History'),

          // --- Bagian Tipe Diabetes ---
          _buildSubHeader('Type of Diabetes:',
              icon: Icons.bloodtype), // Ganti ikon sesuai kebutuhan
          Wrap(
            spacing: 0.0,
            runSpacing: -10.0, // Mengurangi jarak vertikal antar baris Wrap
            crossAxisAlignment: WrapCrossAlignment.center,
            children: ['Type 1', 'Type 2', 'Gestational'].map((type) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: type,
                    groupValue: diabetesType,
                    onChanged: (v) => setState(() => diabetesType = v),
                    activeColor: primaryColor,
                  ),
                  Text(type),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text('Other:', style: TextStyle(color: textColor.withOpacity(0.7))),
          const SizedBox(height: 8),
          TextFormField(
            controller: otherDiabetesTypeController,
            maxLines: 4, // Membuat field menjadi multi-baris
            decoration: _inputDecoration('').copyWith(
              hintText: 'Please enter your type of diabetes',
            ),
          ),
          const SizedBox(height: 24),

          // --- PERUBAHAN UTAMA: Bagian Tahun Diagnosis & Last HbA1c ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolom Kiri: Year of Diagnosis
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubHeader('Year of Diagnosis:',
                        icon: Icons.calendar_today_outlined),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: yearDiagnosisController,
                      decoration:
                          _inputDecoration('').copyWith(hintText: 'e.g 2021'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Kolom Kanan: Last HbA1c
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubHeader('Last HbA1c:',
                        icon: Icons.opacity_outlined),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: lastHbA1cController,
                      decoration:
                          _inputDecoration('').copyWith(hintText: 'E.g 5.0%'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // --- Bagian Current Treatment ---
          _buildSubHeader('Current Treatment:', icon: Icons.list_alt_rounded),
          // Opsi Diet & Exercise
          Row(children: [
            Checkbox(
              value: treatmentDiet,
              onChanged: (v) => setState(() => treatmentDiet = v ?? false),
              activeColor: primaryColor,
            ),
            const Text('Diet & Exercise')
          ]),
          // Opsi Oral Medications
          Row(children: [
            Checkbox(
              value: treatmentOral,
              onChanged: (v) => setState(() => treatmentOral = v ?? false),
              activeColor: primaryColor,
            ),
            const Text('Oral Medications')
          ]),
          if (treatmentOral)
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 8, top: 8, bottom: 8),
              child: TextFormField(
                controller: oralMedicationsController,
                maxLines: 4, // Membuat field menjadi multi-baris
                decoration: _inputDecoration('').copyWith(hintText: 'List:'),
              ),
            ),
          // Opsi Insulin
          Row(children: [
            Checkbox(
              value: treatmentInsulin,
              onChanged: (v) => setState(() => treatmentInsulin = v ?? false),
              activeColor: primaryColor,
            ),
            const Text('Insulin')
          ]),
          if (treatmentInsulin)
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 8, top: 8, bottom: 8),
              child: TextFormField(
                controller: insulinTypeDoseController,
                maxLines: 4, // Membuat field menjadi multi-baris
                decoration:
                    _inputDecoration('').copyWith(hintText: 'type & dose'),
              ),
            ),
        ],
      ),
    );
  }

  // --- HALAMAN 2: Medical History & Risk Factors ---
  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Medical History & Risk Factors'),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: riskFactorItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 10,
              childAspectRatio: 1.8, // Disesuaikan agar pas
            ),
            itemBuilder: (context, index) {
              final key = riskFactorItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubHeader(key,
                      icon: Icons.circle), // Menggunakan ikon circle merah
                  Row(
                    children: ['Yes', 'No'].map((value) {
                      return Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio<String>(
                                value: value,
                                groupValue: riskFactors[key],
                                onChanged: (v) =>
                                    setState(() => riskFactors[key] = v),
                                activeColor: primaryColor),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSubHeader('Smoking:', icon: Icons.smoking_rooms),
          Row(
            children: ['Current', 'Former', 'Never'].map((status) {
              return Expanded(
                child: Row(
                  children: [
                    Radio<String>(
                        value: status,
                        groupValue: smokingStatus,
                        onChanged: (v) => setState(() => smokingStatus = v),
                        activeColor: primaryColor),
                    Text(status),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- HALAMAN 3: Lifestyle & Self-Care ---
  Widget _buildPage3() {
    Widget buildRadioGroup(IconData icon, String title, List<String> options,
        String? groupValue, ValueChanged<String?> onChanged) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubHeader(title, icon: icon),
          Column(
            children: options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: primaryColor,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Lifestyle & Self-Care'),
          buildRadioGroup(
              Icons.bloodtype,
              'Recent Hypoglycemia:',
              ['None', 'Mild', 'Severe'],
              hypoglycemia,
              (v) => setState(() => hypoglycemia = v)),
          buildRadioGroup(
              Icons.directions_run,
              'Physical Activity:',
              ['Regular', 'Occasional', 'Sedentary'],
              physicalActivity,
              (v) => setState(() => physicalActivity = v)),
          buildRadioGroup(
              Icons.restaurant,
              'Diet Quality:',
              ['Healthy', 'Needs Improvement'],
              dietQuality,
              (v) => setState(() => dietQuality = v)),
        ],
      ),
    );
  }

  // --- HALAMAN 4: Physical Signs ---
  Widget _buildPage4() {
    Widget buildFeetSection(String title, List<String> options,
        String? groupValue, ValueChanged<String?> onChanged) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubHeader(title),
          ...options.map((option) {
            return Row(
              children: [
                Radio<String>(
                    value: option,
                    groupValue: groupValue,
                    onChanged: onChanged,
                    activeColor: primaryColor),
                Text(option),
              ],
            );
          }),
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Physical Signs (If Have)'),
          _buildSubHeader('Eyes:', icon: Icons.visibility),
          TextFormField(
              controller: eyesExamDateController,
              decoration: _inputDecoration('Last Exam Date')),
          const SizedBox(height: 12),
          TextFormField(
              controller: eyesFindingsController,
              decoration: _inputDecoration('Findings')),
          const SizedBox(height: 24),
          _buildSubHeader('Kidneys:', icon: Icons.water_drop),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                      controller: kidneyEgfrController,
                      decoration: _inputDecoration('eGFR'))),
              const SizedBox(width: 16),
              Expanded(
                  child: TextFormField(
                      controller: kidneyAcrController,
                      decoration: _inputDecoration('Urine ACR'))),
            ],
          ),
          const SizedBox(height: 24),
          _buildSubHeader('Feet:', icon: Icons.forward_to_inbox_rounded),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: buildFeetSection(
                      'Skin:',
                      ['Normal', 'Dry', 'Ulcer', 'Infection'],
                      feetSkin,
                      (v) => setState(() => feetSkin = v))),
              const SizedBox(width: 16),
              Expanded(
                  child: buildFeetSection(
                      'Deformity:',
                      ['None', 'Bunions', 'Claw toes'],
                      feetDeformity,
                      (v) => setState(() => feetDeformity = v))),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            if (_currentPage == 0) {
              Navigator.of(context).pop();
            } else {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            }
          },
        ),
        title: const Text('Diabetes Form',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [_buildPage1(), _buildPage2(), _buildPage3(), _buildPage4()],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25)), // Tombol lebih bulat
                elevation: 0,
              ),
              onPressed: _currentPage == 3 ? _submitForm : _nextPage,
              child: Text(_currentPage == 3 ? 'Submit Form' : 'Next',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
