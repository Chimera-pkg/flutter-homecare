import 'dart:io';

import 'package:flutter/material.dart';

class NutritionAssessmentPage extends StatefulWidget {
  @override
  _NutritionAssessmentPageState createState() =>
      _NutritionAssessmentPageState();
}

class _NutritionAssessmentPageState extends State<NutritionAssessmentPage> {
  final _formKey = GlobalKey<FormState>();
  int _age = 0;
  String _gender = '';
  String _condition = '';
  String _specialConsideration = '';
  String _medicationHistory = '';
  String _familyHistory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Information'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
              onSaved: (value) => _age = int.parse(value!),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female', 'Other']
                  .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            // ... other form fields
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LifestyleHabitsPage(),
                    ),
                  );
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class LifestyleHabitsPage extends StatefulWidget {
  @override
  _LifestyleHabitsPageState createState() => _LifestyleHabitsPageState();
}

class _LifestyleHabitsPageState extends State<LifestyleHabitsPage> {
  final _formKey = GlobalKey<FormState>();
  double _sleepHours = 8;
  String _activityLevel = '';
  int _exerciseFrequency = 0;
  String _stressLevel = '';
  bool _smoking = false;
  bool _alcohol = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifestyle & Habits'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Slider(
              value: _sleepHours,
              min: 0,
              max: 24,
              divisions: 24,
              label: '${_sleepHours.round()} hours',
              onChanged: (value) {
                setState(() {
                  _sleepHours = value;
                });
              },
            ),
            // ... other form fields for activity level, exercise, stress, etc.
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NutritionHabitsPage(),
                    ),
                  );
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class NutritionHabitsPage extends StatefulWidget {
  @override
  _NutritionHabitsPageState createState() => _NutritionHabitsPageState();
}

class _NutritionHabitsPageState extends State<NutritionHabitsPage> {
  final _formKey = GlobalKey<FormState>();
  int _mealFrequency = 3;
  List<String> _allergies = [];
  List<String> _favoriteFoods = [];
  List<String> _avoidedFoods = [];
  double _waterIntake = 2.0;
  String _pastDiets = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Habits'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ... form fields for nutrition habits
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HealthRatingPage(),
                    ),
                  );
                }
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthRatingPage extends StatefulWidget {
  @override
  _HealthRatingPageState createState() => _HealthRatingPageState();
}

class _HealthRatingPageState extends State<HealthRatingPage> {
  double _rating = 3;
  final List<String> _ratingLabels = [
    'Terrible',
    'Its Bad',
    'Neutral',
    'Its Good',
    'Its Very Good'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Your Health'),
      ),
      body: Column(
        children: [
          Slider(
            value: _rating,
            min: 1,
            max: 5,
            divisions: 4,
            label: _ratingLabels[_rating.round() - 1],
            onChanged: (value) {
              setState(() {
                _rating = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BiomarkerUploadPage(),
              ),
            ),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

class BiomarkerUploadPage extends StatefulWidget {
  @override
  _BiomarkerUploadPageState createState() => _BiomarkerUploadPageState();
}

class _BiomarkerUploadPageState extends State<BiomarkerUploadPage> {
  List<File> _medicalRecords = [];

  Future<void> _pickFiles() async {
    // Implement file picking logic
  }

  Future<void> _submit() async {
    try {
      // Implement submission logic
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Assessment submitted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Medical Records'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickFiles,
            child: const Text('Select Files'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _medicalRecords.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_medicalRecords[index].path.split('/').last),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _medicalRecords.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
