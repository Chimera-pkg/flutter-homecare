import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/personal/personal_cubit.dart';
import 'package:m2health/cubit/personal/personal_state.dart';
import 'package:m2health/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/views/search/search_professional.dart';

class AddOnService extends Equatable {
  final int id;
  final String title;
  final double price;

  const AddOnService({
    required this.id,
    required this.title,
    required this.price,
  });

  factory AddOnService.fromJson(Map<String, dynamic> json) {
    return AddOnService(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [id, title, price];
}

class AddOn extends StatefulWidget {
  final Issue issue;
  final String serviceType;

  AddOn({required this.issue, required this.serviceType});

  @override
  _AddOnState createState() => _AddOnState();
}

class _AddOnState extends State<AddOn> {
  bool isLoading = true;
  late List<bool> _selectedServices;
  List<AddOnService>? serviceData; // Use the type-safe AddOn model
  double _estimatedBudget = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchServiceTitles();
  }

  Future<void> _fetchServiceTitles() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      String endpoint;
      if (widget.serviceType == "Pharmacist") {
        endpoint = '${Const.URL_API}/service-titles/pharma';
      } else if (widget.serviceType == "Radiologist") {
        endpoint = '${Const.URL_API}/service-titles/radiologist';
      } else {
        endpoint = '${Const.URL_API}/service-titles/nurse';
      }

      final response = await Dio().get(
        endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final services = (response.data['data'] as List)
            .map((json) => AddOnService.fromJson(json))
            .toList();

        setState(() {
          serviceData = services;
          _selectedServices =
              List<bool>.generate(serviceData!.length, (_) => false);
          isLoading = false;
        });
      } else {
        _initializeDefaultServiceTitles();
      }
    } catch (e) {
      print('Error fetching service titles: $e');
      _initializeDefaultServiceTitles();
    }
  }

  void _initializeDefaultServiceTitles() {
    if (widget.serviceType == "Pharmacist") {
      serviceData = const [
        AddOnService(id: 1, title: 'Medication Review', price: 15.0),
        AddOnService(id: 2, title: 'Prescription Consultation', price: 10.0),
        AddOnService(id: 3, title: 'Medication Management Plan', price: 25.0),
      ];
    } else if (widget.serviceType == "Radiologist") {
      serviceData = const [
        AddOnService(
            id: 1, title: 'Image Analysis & Interpretation', price: 150.0),
        AddOnService(id: 2, title: 'CT Scan Review', price: 200.0),
        AddOnService(id: 3, title: 'MRI Scan Analysis', price: 250.0),
        AddOnService(id: 4, title: 'X-Ray Examination', price: 100.0),
        AddOnService(id: 5, title: 'Ultrasound Analysis', price: 120.0),
      ];
    } else {
      // "Nurse"
      serviceData = const [
        AddOnService(id: 1, title: 'Medical Escort', price: 20.0),
        AddOnService(id: 2, title: 'Inject', price: 15.0),
        AddOnService(id: 3, title: 'Blood Glucose Check', price: 10.0),
      ];
    }

    setState(() {
      _selectedServices =
          List<bool>.generate(serviceData!.length, (_) => false);
      isLoading = false;
    });
  }

  void _updateEstimatedBudget() {
    double budget = 0.0;
    for (int i = 0; i < _selectedServices.length; i++) {
      if (_selectedServices[i]) {
        budget += serviceData![i].price;
      }
    }
    setState(() {
      _estimatedBudget = budget;
    });
  }

  void _submitData() {
    final String selectedAddOns = _selectedServices
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => serviceData![entry.key].title)
        .join(', ');

    final updatedIssue = widget.issue.copyWith(
      addOn: selectedAddOns,
      estimatedBudget: _estimatedBudget,
    );

    context.read<PersonalCubit>().updateIssue(updatedIssue);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
          serviceType: widget.serviceType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add-On Services')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (serviceData == null || serviceData!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add-On Services')),
        body: const Center(child: Text('No services available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.serviceType == "Pharmacist"
              ? 'Pharmacist Add-On Services'
              : widget.serviceType == "Radiologist"
                  ? 'Radiologist Add-On Services'
                  : 'Nursing Add-On Services',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: serviceData!.length,
                itemBuilder: (context, i) {
                  final service = serviceData![i];
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: _selectedServices[i],
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedServices[i] = value ?? false;
                            _updateEstimatedBudget();
                          });
                        },
                        activeColor: const Color(0xFF35C5CF),
                      ),
                      title: Text(
                        service.title,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '\$${service.price}',
                        style: const TextStyle(
                          color: Color(0xFF35C5CF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(Icons.info_outline_rounded,
                          color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Estimated Budget',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$$_estimatedBudget',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                  'Book Appointment',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
