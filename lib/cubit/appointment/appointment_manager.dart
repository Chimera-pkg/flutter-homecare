import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/appointment/pages/appointment_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/cubit/appointment/pages/provider_appointment_page.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/const.dart';

/// Manages appointment routing based on user role
class AppointmentManager {
  static const List<String> providerRoles = [
    'pharmacist',
    'nurse',
    'radiologist'
  ];

  /// Check if the current user is a provider
  static Future<bool> isProvider() async {
    final role = await Utils.getSpString(Const.ROLE);
    return role != null && providerRoles.contains(role.toLowerCase());
  }

  /// Get the provider type for the current user
  static Future<String?> getProviderType() async {
    final role = await Utils.getSpString(Const.ROLE);
    if (role != null && providerRoles.contains(role.toLowerCase())) {
      return role.toLowerCase();
    }
    return null;
  }

  /// Navigate to appropriate appointment page based on user role
  // static Future<void> navigateToAppointmentPage(BuildContext context) async {
  //   try {
  //     final isUserProvider = await isProvider();

  //     if (isUserProvider) {
  //       final providerType = await getProviderType();
  //       if (providerType != null) {
  //         // Navigate to provider appointment page
  //         context.push('${AppRoutes.providerAppointment}/$providerType');
  //       }
  //     } else {
  //       // Navigate to patient appointment page
  //       context.push(AppRoutes.appointment);
  //     }
  //   } catch (e) {
  //     print('Error navigating to appointment page: $e');
  //     // Show error to user
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error accessing appointments: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  /// Create appropriate appointment widget based on user role
  static Future<Widget> createAppointmentWidget() async {
    try {
      final isUserProvider = await isProvider();

      if (isUserProvider) {
        return const ProviderAppointmentPage();
      }

      // Default to patient appointment page
      return const AppointmentPage();
    } catch (e) {
      print('Error creating appointment widget: $e');
      // Return a default error widget
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Error loading appointments'),
              const SizedBox(height: 8),
              Text(e.toString()),
            ],
          ),
        ),
      );
    }
  }
}
