import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/personal/personal_state.dart';
import 'package:m2health/utils.dart';
import '../search/search_professional.dart';

class RadiologistAddOn extends StatefulWidget {
  final Issue issue;
  final String serviceType;

  RadiologistAddOn({required this.issue, required this.serviceType});

  @override
  _RadiologistAddOnState createState() => _RadiologistAddOnState();
}

class _RadiologistAddOnState extends State<RadiologistAddOn> {
  bool isLoading = true;
  late List<bool> _selectedServices;
  List<Map<String, dynamic>>? serviceData;
  double _estimatedBudget = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchServiceTitles();
  }

  Future<void> _fetchServiceTitles() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      // Try to fetch radiologist services from API
      final endpoint = '${Const.URL_API}/service-titles/radiologist';

      final response = await Dio().get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final servicesData =
            List<Map<String, dynamic>>.from(response.data['data']);

        setState(() {
          serviceData = servicesData;
          _selectedServices =
              List<bool>.generate(serviceData!.length, (index) => false);
          isLoading = false;
        });
      } else {
        _initializeDefaultServiceTitles();
      }
    } catch (e) {
      print('Error fetching radiologist service titles: $e');
      _initializeDefaultServiceTitles();
    }
  }

  void _initializeDefaultServiceTitles() {
    // Default radiologist services
    serviceData = [
      {'id': 1, 'title': 'Image Analysis & Interpretation', 'price': 150.0},
      {'id': 2, 'title': 'CT Scan Review', 'price': 200.0},
      {'id': 3, 'title': 'MRI Scan Analysis', 'price': 250.0},
      {'id': 4, 'title': 'X-Ray Examination', 'price': 100.0},
      {'id': 5, 'title': 'Ultrasound Analysis', 'price': 120.0},
      {'id': 6, 'title': 'Mammography Review', 'price': 180.0},
      {'id': 7, 'title': 'PET Scan Interpretation', 'price': 300.0},
      {'id': 8, 'title': '3D Reconstruction Analysis', 'price': 220.0},
      {'id': 9, 'title': 'Contrast Study Review', 'price': 160.0},
      {'id': 10, 'title': 'Second Opinion Consultation', 'price': 100.0},
    ];

    _selectedServices =
        List<bool>.generate(serviceData!.length, (index) => false);

    setState(() {
      isLoading = false;
    });
  }

  void _updateEstimatedBudget() {
    _estimatedBudget = 0.0;

    for (int i = 0; i < _selectedServices.length; i++) {
      if (_selectedServices[i]) {
        final price = serviceData![i]['price'];
        _estimatedBudget += (price is int ? price.toDouble() : price) as double;
      }
    }
  }

  void _submitData() async {
    final token = await Utils.getSpString(Const.TOKEN);

    final data = {
      "add_on": _selectedServices
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) => serviceData![entry.key]['title'])
          .join(', '),
      "estimated_budget": _estimatedBudget,
      "case_type": "radiology",
      "updated_at": DateTime.now().toIso8601String(),
    };

    print('Radiologist add-on data to be submitted: $data');

    try {
      final response = await Dio().put(
        '${Const.API_PERSONAL_CASES}/${widget.issue.id}',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(
              serviceType: 'Radiologist',
            ),
          ),
        );
      } else {
        print(
            'Failed to submit radiologist add-on data: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error submitting radiologist add-on: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Radiologist Add-On Services',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (serviceData == null || serviceData!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Radiologist Add-On Services',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: Text('No radiologist services available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Radiologist Add-On Services',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF35C5CF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.medical_services, color: Color(0xFF35C5CF)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Select additional radiology services for comprehensive analysis',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF35C5CF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: serviceData!.length,
                itemBuilder: (context, i) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedServices[i] = !_selectedServices[i];
                            _updateEstimatedBudget();
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _selectedServices[i]
                                ? const Color(0xFF35C5CF)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: const Color(0xFF35C5CF)),
                          ),
                          child: _selectedServices[i]
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 16)
                              : null,
                        ),
                      ),
                      title: Text(
                        serviceData![i]['title'] as String,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.visible,
                      ),
                      subtitle: Text(
                        '\$${serviceData![i]['price']}',
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
                  'Estimated Total Budget',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${_estimatedBudget.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Color(0xFF35C5CF),
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
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
                  'Find Radiologists',
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
