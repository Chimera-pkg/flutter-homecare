import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/profiles/presentation/bloc/manage_services_cubit.dart';
import 'package:collection/collection.dart'; // For groupBy

class ManageServicesArgs {
  final String role;
  final List<AddOnService> currentServices;
  ManageServicesArgs({required this.role, required this.currentServices});
}

class ManageProvidedServicesPage extends StatefulWidget {
  const ManageProvidedServicesPage({super.key});

  @override
  State<ManageProvidedServicesPage> createState() =>
      _ManageProvidedServicesPageState();
}

class _ManageProvidedServicesPageState
    extends State<ManageProvidedServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Services",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<ManageServicesCubit, ManageServicesState>(
        listener: (context, state) {
          if (state is ManageServicesSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Services updated successfully'),
                  backgroundColor: Colors.green),
            );
            Navigator.pop(context, true);
          } else if (state is ManageServicesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is ManageServicesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ManageServicesLoaded) {
            if (state.allServices.isEmpty) {
              return const Center(
                  child: Text("No available services found for your role."));
            }

            // Group services by type
            final groupedServices =
                groupBy(state.allServices, (AddOnService s) => s.serviceType);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Select the services you provide to patients. These will appear in search results.",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedServices.length,
                    itemBuilder: (context, index) {
                      final serviceType = groupedServices.keys.elementAt(index);
                      final services = groupedServices[serviceType]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                              context, serviceType, services, state),
                          ...services.map((service) {
                            final isSelected = state.selectedServices
                                .any((s) => s.id == service.id);
                            return CheckboxListTile(
                              title: Text(service.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle:
                                  Text("\$${service.price.toStringAsFixed(2)}"),
                              value: isSelected,
                              activeColor: Const.aqua,
                              onChanged: (_) {
                                context
                                    .read<ManageServicesCubit>()
                                    .toggleService(service);
                              },
                            );
                          }),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ManageServicesCubit>().saveServices();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Const.aqua,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Save Changes",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            );
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String serviceType,
      List<AddOnService> services, ManageServicesLoaded state) {
    String title = "Services";
    Color color = Colors.grey.shade200;
    Color textColor = Colors.black87;

    if (serviceType == 'nursing') {
      title = "Primary Nursing";
      color = const Color(0xFF9AE1FF).withValues(alpha: 0.3);
    } else if (serviceType == 'specialized_nursing') {
      title = "Specialized Nursing";
      color = const Color(0xFFB28CFF).withValues(alpha: 0.2);
    } else if (serviceType == 'pharmacy') {
      title = "Pharmacy Services";
      color = const Color(0xFFF79E1B).withValues(alpha: 0.1);
    } else if (serviceType == 'radiology') {
      title = "Radiology Services";
    }

    // Check if all services in this category are currently selected
    final areAllSelected = services.isNotEmpty &&
        services.every((s) =>
            state.selectedServices.any((selected) => selected.id == s.id));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),
          Row(
            children: [
              Text(
                "Select All",
                style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                    fontWeight: FontWeight.w500),
              ),
              Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: areAllSelected,
                  activeColor: Const.aqua,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (bool? value) {
                    context
                        .read<ManageServicesCubit>()
                        .toggleCategoryServices(services, value ?? false);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
