import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/diabetes/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/pages/index.dart';
import 'package:m2health/cubit/diabetes/widgets/diabetes_form_widget.dart';

class DiabetesFormPage extends StatelessWidget {
  const DiabetesFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiabetesFormCubit(),
      child: const DiabetesFormView(),
    );
  }
}

class DiabetesFormView extends StatefulWidget {
  const DiabetesFormView({super.key});

  @override
  State<DiabetesFormView> createState() => _DiabetesFormViewState();
}

class _DiabetesFormViewState extends State<DiabetesFormView> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
          onPressed: () {
            if (_currentPage == 0) {
              Navigator.of(context).pop();
            } else {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: const [
          DiabetesHistoryPage(),
          RiskFactorsPage(),
          LifestyleSelfCarePage(),
          PhysicalSignsPage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)), // Tombol lebih bulat
            elevation: 0,
          ),
          onPressed: () {
            if (_currentPage == 3) {
              context.read<DiabetesFormCubit>().submitForm();
            } else {
              _nextPage();
            }
          },
          child: Text(
            _currentPage == 3 ? 'Submit Form' : 'Next',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
