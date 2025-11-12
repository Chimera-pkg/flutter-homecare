import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/booking_appointment/add_on_services/presentation/bloc/add_on_service_cubit.dart';
import 'package:m2health/features/booking_appointment/add_on_services/presentation/bloc/add_on_service_state.dart';
import 'package:m2health/service_locator.dart';

class AddOnServicePage extends StatelessWidget {
  final String serviceType;
  final Function(List<AddOnService>) onComplete;
  final List<AddOnService>? initialSelectedServices;

  const AddOnServicePage({
    super.key,
    required this.serviceType,
    required this.onComplete,
    this.initialSelectedServices,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddOnServiceCubit(
        sl(),
        initialSelectedServices: initialSelectedServices ?? [],
      ),
      child: AddOnServiceView(
        serviceType: serviceType,
        onComplete: onComplete,
      ),
    );
  }
}

class AddOnServiceView extends StatefulWidget {
  final String serviceType;
  final Function(List<AddOnService>) onComplete;

  const AddOnServiceView({
    super.key,
    required this.serviceType,
    required this.onComplete,
  });

  @override
  State<AddOnServiceView> createState() => AddOnServiceViewState();
}

class AddOnServiceViewState extends State<AddOnServiceView> {
  @override
  void initState() {
    super.initState();
    context.read<AddOnServiceCubit>().loadAddOnServices(widget.serviceType);
  }

  @override
  Widget build(BuildContext context) {
    String getTitle(String serviceType) {
      switch (serviceType) {
        case 'nurse':
          return 'Nursing Procedures';
        case 'specialized_nurse':
          return 'Specialized Nursing Procedures';
        case 'pharmacist':
          return 'Pharmacy Services';
        case 'radiologist':
          return 'Radiology Services';
        default:
          return 'Add On Services';
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            getTitle(widget.serviceType),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: _buildAddOnList(context),
              ),
              const SizedBox(height: 10),
              _buildBudgetSection(context),
              const SizedBox(height: 10),
              _buildBookButton(context),
            ],
          ),
        ));
  }

  Widget _buildAddOnList(BuildContext context) {
    Future<void> refreshAddOnServices() async {
      context.read<AddOnServiceCubit>().loadAddOnServices(widget.serviceType);
    }

    return RefreshIndicator(
      onRefresh: refreshAddOnServices,
      child: BlocBuilder<AddOnServiceCubit, AddOnServiceState>(
        builder: (context, state) {
          if (state.status == AddOnServiceStateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AddOnServiceStateStatus.error) {
            return Center(
                child: Text(
                    state.errorMessage ?? 'Error loading add-on services.'));
          }

          if (state.status == AddOnServiceStateStatus.loaded) {
            if (state.addOnServices.isEmpty) {
              return const Center(child: Text('No add-on services available.'));
            }

            final availableServices = state.addOnServices;
            return ListView.builder(
              itemCount: availableServices.length,
              itemBuilder: (context, index) {
                final service = availableServices[index];
                final isSelected =
                    state.selectedAddOnServices.any((s) => s.id == service.id);

                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        context
                            .read<AddOnServiceCubit>()
                            .toggleAddOnServiceSelection(service);
                      },
                      activeColor: const Color(0xFF35C5CF),
                    ),
                    title: Text(
                      service.name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '\$${service.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF35C5CF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.info_outline_rounded,
                        color: Colors.grey),
                  ),
                );
              },
            );
          }

          // Fallback
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBudgetSection(BuildContext context) {
    final estimatedBudget =
        context.watch<AddOnServiceCubit>().state.estimatedBudget;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Estimated Budget',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '\$${estimatedBudget.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _buildBookButton(BuildContext context) {
    final state = context.watch<AddOnServiceCubit>().state;
    final isButtonEnabled = state.selectedAddOnServices.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: isButtonEnabled
            ? () => widget.onComplete(state.selectedAddOnServices)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF35C5CF),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Book Appointment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
