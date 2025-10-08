import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/profiles/domain/entities/certificate.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';
import 'package:m2health/cubit/profiles/domain/usecases/index.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/certificate_cubit.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/certificate_state.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/profile_cubit.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/profile_state.dart';
import 'package:m2health/cubit/profiles/presentation/widgets/add_edit_certificate_dialog.dart';

class EditProfessionalProfilePage extends StatefulWidget {
  final Profile profile;
  const EditProfessionalProfilePage({super.key, required this.profile});

  @override
  State<EditProfessionalProfilePage> createState() =>
      _EditProfessionalProfilePageState();
}

class _EditProfessionalProfilePageState
    extends State<EditProfessionalProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedAvatar;

  // Controllers
  late TextEditingController _usernameController;
  late TextEditingController _aboutMeController;
  late TextEditingController _workHoursController;
  late TextEditingController _workplaceController;
  String? _selectedJobTitle;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _usernameController = TextEditingController(text: p.username);
    _aboutMeController =
        TextEditingController(text: p.professionalDetail?.aboutMe ?? '');
    _workHoursController =
        TextEditingController(text: p.professionalDetail?.workingHours ?? '');
    _workplaceController =
        TextEditingController(text: p.professionalDetail?.workPlace ?? '');
    _selectedJobTitle = p.professionalDetail?.jobTitle;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _aboutMeController.dispose();
    _workHoursController.dispose();
    _workplaceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      setState(() => _selectedAvatar = File(image.path));
    }
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      final params = UpdateProfileParams(
        // Basic info
        username: _usernameController.text,
        avatar: _selectedAvatar,
        // Professional info
        jobTitle: _selectedJobTitle,
        aboutMe: _aboutMeController.text,
        workHours: _workHoursController.text,
        workPlace: _workplaceController.text,
      );
      context.read<ProfileCubit>().updateProfile(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final professionalDetail = profile.professionalDetail;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CertificateCubit, CertificateState>(
            listener: (context, state) {
              if (state is CertificateSuccess) {
                // Tampilkan pesan sukses
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green));
                context.read<ProfileCubit>().loadProfile();
              } else if (state is CertificateError) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red));
              }
            },
          ),
          BlocListener<ProfileCubit, ProfileState>(listener: (context, state) {
            if (state is ProfileSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green));
              Navigator.of(context).pop();
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red));
            }
          })
        ],
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _AvatarSection(
                avatarUrl: profile.avatar,
                selectedImage: _selectedAvatar,
                onTap: _pickImage,
              ),
              const SizedBox(height: 24),
              _TextFieldWidget(
                  controller: _usernameController, label: 'Full Name'),
              const SizedBox(height: 16),
              _JobTitleDropdown(
                currentJobTitle: professionalDetail?.jobTitle,
                onChanged: (value) {
                  setState(() {
                    _selectedJobTitle = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _TextFieldWidget(
                controller: _aboutMeController,
                label: 'About me description',
                hint:
                    'Please introduce yourself: your experienced, any notable achievements, etc.',
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              const Text('Working Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              _TextFieldWidget(
                  controller: _workHoursController,
                  label: 'Working Hours',
                  hint: 'E.g: Monday - Friday, 09.00AM - 05.00 PM'),
              const SizedBox(height: 16),
              _TextFieldWidget(
                  controller: _workplaceController,
                  label: 'Workplace',
                  hint: 'Type or search building or places here'),
              const SizedBox(height: 24),
              BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                final certifications = (state is ProfileLoaded)
                    ? state.profile.professionalDetail?.certificates
                    : widget.profile.professionalDetail?.certificates;
                return _CertificatesSection(
                  certifications: certifications ?? [],
                  onAdd: _showAddCertificateDialog,
                  onEdit: _showEditCertificateDialog,
                  onRemove: _showDeleteConfirmationDialog,
                );
              }),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Const.aqua,
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _onSavePressed,
          child: const Text('Save'),
        ),
      ),
    );
  }

  void _showAddCertificateDialog() {
    showDialog(
      context: context,
      builder: (_) => AddEditCertificateDialog(
        onSave: (title, regNum, issuedOn, file) {
          final params = CreateCertificateParams(
            title: title,
            registrationNumber: regNum,
            issuedOn: issuedOn,
            file: file!,
          );
          context.read<CertificateCubit>().addCertificate(params);
        },
      ),
    );
  }

  void _showEditCertificateDialog(Certificate cert) {
    showDialog(
      context: context,
      builder: (_) => AddEditCertificateDialog(
        certificate: cert,
        onSave: (title, regNum, issuedOn, file) {
          final params = UpdateCertificateParams(
            id: cert.id,
            title: title,
            registrationNumber: regNum,
            issuedOn: issuedOn,
            file: file,
          );
          context.read<CertificateCubit>().editCertificate(params);
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(int certId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to remove this?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<CertificateCubit>().removeCertificate(certId);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final String? avatarUrl;
  final File? selectedImage;
  final VoidCallback onTap;

  const _AvatarSection({
    this.avatarUrl,
    this.selectedImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                width: 96,
                height: 96,
                color: Colors.grey.shade200,
                child: selectedImage != null
                    ? Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      )
                    : (avatarUrl != null && avatarUrl!.isNotEmpty)
                        ? Image.network(
                            avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person,
                                    size: 60, color: Colors.grey),
                          )
                        : const Icon(Icons.person,
                            size: 60, color: Colors.grey),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Center(
                  child: Text(
                    'CHANGE',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;

  const _TextFieldWidget({
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(hintText: hint),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _JobTitleDropdown extends StatelessWidget {
  final String? currentJobTitle;
  final ValueChanged<String?> onChanged;

  const _JobTitleDropdown({
    this.currentJobTitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const jobTitles = [
      'Nurse',
      'Pharmacist',
      'Radiologist',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job Title',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        DropdownButtonFormField<String>(
          value: jobTitles.contains(currentJobTitle) ? currentJobTitle : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Const.aqua,
                width: 1.5,
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          dropdownColor: Colors.white,
          items: jobTitles.map((title) {
            return DropdownMenuItem<String>(
                value: title,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ));
          }).toList(),
          onChanged: onChanged,
          validator: (value) =>
              value == null ? 'Please select a job title' : null,
        ),
      ],
    );
  }
}

class _CertificatesSection extends StatelessWidget {
  final List<Certificate> certifications;
  final VoidCallback onAdd;
  final Function(Certificate) onEdit;
  final Function(int) onRemove;

  const _CertificatesSection({
    required this.certifications,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Professional Certificates',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Const.aqua,
                side: const BorderSide(color: Const.aqua),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (certifications.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No certificate added yet.'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: certifications.length,
            itemBuilder: (context, index) {
              final cert = certifications[index];
              return CertificateCard(
                certification: cert,
                onEdit: () => onEdit(cert),
                onRemove: () => onRemove(cert.id),
              );
            },
          )
      ],
    );
  }
}

class CertificateCard extends StatelessWidget {
  final Certificate certification;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const CertificateCard({
    super.key,
    required this.certification,
    required this.onEdit,
    required this.onRemove,
  });

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM dd, yyyy').format(date);
    } catch (e) {
      log(e.toString());
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              certification.fileURL,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 120,
                height: 80,
                color: Colors.grey[200],
                child:
                    const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  certification.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B3A55),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID Numbers: ${certification.registrationNumber}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Issued on ${formatDate(certification.issuedOn)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Const.aqua),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 12,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
