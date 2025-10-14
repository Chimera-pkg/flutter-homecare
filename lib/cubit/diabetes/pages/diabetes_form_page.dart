import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/cubit/diabetes/pages/form/index.dart';
import 'package:m2health/cubit/diabetes/widgets/diabetes_form_widget.dart';
import 'package:m2health/route/app_routes.dart';

class DiabetesFormPage extends StatefulWidget {
  const DiabetesFormPage({super.key});

  @override
  State<DiabetesFormPage> createState() => _DiabetesFormPageState();
}

class _DiabetesFormPageState extends State<DiabetesFormPage> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _canPop = false;

  final _diabetesHistoryPageKey = GlobalKey<DiabetesHistoryPageState>();
  final _riskFactorsPageKey = GlobalKey<RiskFactorsPageState>();
  final _lifestylePageKey = GlobalKey<LifestyleSelfCarePageState>();
  final _physicalSignPageKey = GlobalKey<PhysicalSignsPageState>();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _validatePage() {
    String? error;
    switch (_currentPage) {
      case 0:
        return _diabetesHistoryPageKey.currentState?.validate() ?? true;
      case 1:
        error = _riskFactorsPageKey.currentState?.validate();
      case 2:
        error = _lifestylePageKey.currentState?.validate();
      case 3:
        return _physicalSignPageKey.currentState?.validate() ?? true;
      default:
        return false;
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return false;
    }
    return true;
  }

  void _nextPage() {
    if (_currentPage >= 3) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _submitFormAndShowDialog() async {
    final success = await context.read<DiabetesFormCubit>().submitForm();
    if (!mounted) return;
    if (!success) {
      final errorMessage =
          context.read<DiabetesFormCubit>().state.errorMessage ??
              'An unknown error occurred.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Success!'),
        content: const Text(
            'Your Diabetes Profile has been submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              GoRouter.of(context).goNamed(AppRoutes.diabeticProfileSummary);
            },
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDiscardDialog() async {
    final bool? shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Discard Progress?'),
          content: const Text(
              'Are you sure you want to leave? Any unsaved changes will be lost.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Don't discard
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Discard
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
    return shouldDiscard ?? false;
  }

  void _handlePop() async {
    if (_currentPage != 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    final bool didConfirm = await _showDiscardDialog();

    if (didConfirm && mounted) {
      setState(() {
        _canPop = true;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diabetes Form',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handlePop,
        ),
      ),
      body: PopScope(
        canPop: _canPop,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            return;
          }
          _handlePop();
        },
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            DiabetesHistoryPage(key: _diabetesHistoryPageKey),
            RiskFactorsPage(key: _riskFactorsPageKey),
            LifestyleSelfCarePage(key: _lifestylePageKey),
            PhysicalSignsPage(key: _physicalSignPageKey),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<DiabetesFormCubit, DiabetesFormState>(
          builder: (context, state) {
            return PrimaryButton(
              text: _currentPage == 3 ? 'Submit Form' : 'Next',
              isLoading: state.isLoading,
              onPressed: () {
                if (!_validatePage()) return;
                if (_currentPage == 3) {
                  _submitFormAndShowDialog();
                } else {
                  _nextPage();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
