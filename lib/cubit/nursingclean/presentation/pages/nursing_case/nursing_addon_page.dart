import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/nursingclean/const.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/add_on_services_state.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_bloc.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_state.dart';
import 'package:m2health/cubit/nursingclean/presentation/pages/professional/search_professional_page.dart';

class NursingAddOnPage extends StatefulWidget {
  const NursingAddOnPage({super.key});

  @override
  State<NursingAddOnPage> createState() => _NursingAddOnPageState();
}

class _NursingAddOnPageState extends State<NursingAddOnPage> {
  @override
  void initState() {
    super.initState();
    final nursingState = context.read<NursingCaseBloc>().state;
    if (nursingState is NursingCaseLoaded && nursingState.serviceType != null) {
      context
          .read<NursingCaseBloc>()
          .add(FetchNursingAddOnServices(nursingState.serviceType!));
    } else {
      // Fallback or error, though serviceType should always be set here
      context
          .read<NursingCaseBloc>()
          .add(FetchNursingAddOnServices(NurseServiceType.primaryNurse));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nursing Add-On Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<NursingCaseBloc, NursingCaseState>(
        builder: (context, state) {
          if (state is! NursingCaseLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final addOnState = state.addOnServicesState;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child:
                      _buildAddOnList(context, addOnState, state.nursingCase),
                ),
                const SizedBox(height: 10),
                _buildBudgetSection(state.nursingCase),
                const SizedBox(height: 10),
                _buildBookButton(context, state.serviceType),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddOnList(BuildContext context, AddOnServicesState addOnState,
      NursingCase nursingCase) {
    Future<void> refreshAddOnServices() async {
      final nursingState = context.read<NursingCaseBloc>().state;
      if (nursingState is NursingCaseLoaded &&
          nursingState.serviceType != null) {
        context
            .read<NursingCaseBloc>()
            .add(FetchNursingAddOnServices(nursingState.serviceType!));
      }
    }

    return RefreshIndicator(
      onRefresh: refreshAddOnServices,
      child: Builder(
        builder: (context) {
          if (addOnState is AddOnServicesLoading ||
              addOnState is AddOnServicesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (addOnState is AddOnServicesError) {
            return Center(child: Text(addOnState.message));
          }

          if (addOnState is AddOnServicesLoaded) {
            if (addOnState.services.isEmpty) {
              return const Center(child: Text('No add-on services available.'));
            }

            final availableServices = addOnState.services;
            return ListView.builder(
              itemCount: availableServices.length,
              itemBuilder: (context, index) {
                final service = availableServices[index];
                final isSelected =
                    nursingCase.addOnServices.any((s) => s.id == service.id);

                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        context
                            .read<NursingCaseBloc>()
                            .add(ToggleAddOnService(service));
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

  Widget _buildBudgetSection(NursingCase nursingCase) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Estimated Budget',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '\$${nursingCase.estimatedBudget.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _buildBookButton(BuildContext context, NurseServiceType? serviceType) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchProfessionalPage(
                serviceType: serviceType?.apiValue ??
                    NurseServiceType.primaryNurse.apiValue,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF35C5CF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
