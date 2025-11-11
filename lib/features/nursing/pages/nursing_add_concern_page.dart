import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/nursing/personal/nursing_personal_cubit.dart';
import 'package:m2health/core/presentation/widgets/image_preview.dart';
import 'package:m2health/utils.dart'; // Assuming Utils contains the method to get the token
import 'dart:io';

class AddConcernPage extends StatefulWidget {
  @override
  _AddConcernPageState createState() => _AddConcernPageState();
}

class _AddConcernPageState extends State<AddConcernPage> {
  TextEditingController _issueTitleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final List<File?> _images = List.filled(3, null); // To hold up to 3 images

  Future<void> setImageAt(int index, File? image) async {
    setState(() {
      _images[index] = image;
    });
  }

  Future<void> _submitData() async {
    final issueTitle = _issueTitleController.text;
    final description = _descriptionController.text;

    if (issueTitle.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Issue title and description are required.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final token = await Utils.getSpString(Const.TOKEN);

      // Create FormData without the related_health_record_id field for now
      FormData formData = FormData.fromMap({
        "user_id": 1,
        "title": issueTitle,
        "description": description,
        "mobility_status": "wheel",
        "related_health_record_id": null, // Make it null to make it optional
        "add_on": "additional",
        "estimated_budget": 1000,
      });

      // Add images to FormData
      for (final image in _images.where((img) => img != null)) {
        formData.files.add(
          MapEntry(
            "images[]",
            await MultipartFile.fromFile(
              image!.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }

      // Debug: Print the request data
      print('Sending request with data:');
      print('Headers: Bearer $token');
      print('FormData fields: ${formData.fields}');
      print('FormData files: ${formData.files}');

      final response = await Dio().post(
        '${Const.API_NURSING_PERSONAL_CASES}',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) {
            return status! < 500; // Accept all status codes less than 500
          },
        ),
      );

      // Debug: Print the response
      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Reload the data on the previous page
        context.read<NursingPersonalCubit>().loadPersonalDetails();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Issue submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 422) {
        // Handle validation errors but allow continuing for now
        final errorMessage = response.data['message'] ?? 'Validation failed';
        final errors = response.data['errors'];
        print('Validation errors: $errors');

        if (errors != null &&
            errors
                .any((error) => error['field'] == 'related_health_record_id')) {
          // Only show a warning for this specific error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Note: Related health record is currently optional'),
              backgroundColor: Colors.orange,
            ),
          );

          // Navigate to the next page anyway
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => PersonalPage()),
          // );
        } else {
          // Show error for other validation issues
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        throw Exception('Failed to submit data: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioError Type: ${e.type}');
      print('DioError Message: ${e.message}');
      print('DioError Response: ${e.response?.data}');

      String errorMessage = 'Error submitting issue: ';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage += e.response?.data['message'];
      } else {
        errorMessage += e.message ?? 'Unknown error';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('General Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add an Issue',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tell us your concerns',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 338,
              height: 50,
              child: TextField(
                controller: _issueTitleController,
                decoration: InputDecoration(
                  hintText: 'Issue Title',
                  hintStyle:
                      const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: 338,
              height: 129,
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText:
                      'Please enter questions, concerns, relevant symptoms related to your case along with related keywords.',
                  hintStyle:
                      const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                spacing: 30,
                children: [
                  ...List.generate(_images.length, (index) {
                    return ImagePreview(
                      imageFile: _images[index],
                      onChooseImage: (image) => setImageAt(index, image),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: 352,
          height: 58,
          child: ElevatedButton(
            onPressed: _submitData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF35C5CF),
            ),
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

void showAddConcernPage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => BlocProvider.value(
      value: context.read<NursingPersonalCubit>(),
      child: AddConcernPage(),
    ),
  );
}
