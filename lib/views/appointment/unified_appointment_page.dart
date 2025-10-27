import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/appointment/appointment_manager.dart';
import 'package:m2health/cubit/appointment/appointment_cubit.dart';
import 'package:m2health/cubit/appointment/provider_appointment_cubit.dart';
import 'package:m2health/cubit/appointment/appointment_page.dart';
import 'package:m2health/views/appointment/provider_appointment_page.dart';

/// Unified appointment entry widget that automatically routes to appropriate view
class UnifiedAppointmentPage extends StatefulWidget {
  static const String route = '/unified-appointment';

  const UnifiedAppointmentPage({super.key});

  @override
  State<UnifiedAppointmentPage> createState() => _UnifiedAppointmentPageState();
}

class _UnifiedAppointmentPageState extends State<UnifiedAppointmentPage> {
  late Future<Widget> _appointmentWidgetFuture;

  @override
  void initState() {
    super.initState();
    _appointmentWidgetFuture = _loadAppointmentWidget();
  }

  Future<Widget> _loadAppointmentWidget() async {
    final isUserProvider = await AppointmentManager.isProvider();

    if (isUserProvider) {
      final providerType = await AppointmentManager.getProviderType();
      if (providerType != null) {
        return ProviderAppointmentPage(providerType: providerType);
      }
    }

    return const AppointmentPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _appointmentWidgetFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Appointments'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Appointments'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _appointmentWidgetFuture = _loadAppointmentWidget();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Appointments'),
            ),
            body: const Center(
              child: Text('No appointment data available'),
            ),
          );
        }
      },
    );
  }
}
