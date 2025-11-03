import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';
import 'dart:io';
import 'package:m2health/cubit/profiles/domain/usecases/update_profile.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/profile_cubit.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/profile_state.dart';

class EditBasicInfoPage extends StatefulWidget {
  const EditBasicInfoPage({super.key});

  @override
  State<EditBasicInfoPage> createState() => _EditBasicInfoPageState();
}

class _EditBasicInfoPageState extends State<EditBasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late Profile? profile;
  File? _selectedImage;

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _drugAllergyController;
  String? _selectedGender;

  final List<String> genderItems = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    profile = context.read<ProfileCubit>().state is PatientProfileLoaded
        ? (context.read<ProfileCubit>().state as PatientProfileLoaded).profile
        : null;
    _nameController = TextEditingController(text: profile?.name);
    _ageController = TextEditingController(text: profile?.age?.toString());
    _weightController =
        TextEditingController(text: profile?.weight?.toString());
    _heightController =
        TextEditingController(text: profile?.height?.toString());
    _phoneController = TextEditingController(text: profile?.phoneNumber);
    _addressController = TextEditingController(text: profile?.homeAddress);
    _drugAllergyController = TextEditingController(text: profile?.drugAllergy);
    _selectedGender =
        genderItems.contains(profile?.gender) ? profile?.gender : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _drugAllergyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final params = UpdateProfileParams(
        name: _nameController.text,
        age: int.tryParse(_ageController.text),
        weight: double.tryParse(_weightController.text),
        height: double.tryParse(_heightController.text),
        phoneNumber: _phoneController.text,
        homeAddress: _addressController.text,
        gender: _selectedGender,
        drugAllergy: _drugAllergyController.text,
        avatar: _selectedImage,
      );
      context.read<ProfileCubit>().updateProfile(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.message), backgroundColor: Colors.green));
          Navigator.pop(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Profile Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(58),
                          child: _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                )
                              : profile != null && profile?.avatar != null
                                  ? Image.network(
                                      profile!.avatar!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                    ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF40E0D0),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedImage != null)
                  Center(
                    child: TextButton(
                      onPressed: _removeImage,
                      child: const Text(
                        'Remove Image',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String?>(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: genderItems.map((String value) {
                    return DropdownMenuItem<String?>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  initialValue: _selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight (KG)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _heightController,
                  decoration: InputDecoration(
                    labelText: 'Height (CM)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Home Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _drugAllergyController,
                  decoration: InputDecoration(
                    labelText: 'Drug Allergies',
                    hintText: 'e.g. Penicillin, Aspirin',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
            final isUpdating = state is ProfileSaving;
            return ElevatedButton(
              onPressed: isUpdating ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Const.aqua,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isUpdating
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            );
          }),
        ),
      ),
    );
  }
}
