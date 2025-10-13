import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/pages/form/index.dart';
import 'package:m2health/cubit/diabetes/widgets/diabetes_form_widget.dart';

class DiabetesFormPage extends StatefulWidget {
  const DiabetesFormPage({super.key});

  @override
  State<DiabetesFormPage> createState() => _DiabetesFormPageState();
}

class _DiabetesFormPageState extends State<DiabetesFormPage> {
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
        child: PrimaryButton(
          text: _currentPage == 3 ? 'Submit Form' : 'Next',
          onPressed: () {
            if (_currentPage == 3) {
              context.read<DiabetesFormCubit>().submitForm();
            } else {
              _nextPage();
            }
          },
        ),
      ),
    );
  }
}
