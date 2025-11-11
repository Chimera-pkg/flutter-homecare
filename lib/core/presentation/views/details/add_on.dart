import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/personal/personal_cubit.dart';
import 'package:m2health/features/personal/personal_state.dart';
import 'package:m2health/core/data/models/service_config.dart';
import 'package:m2health/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/presentation/views/search/search_professional.dart';

abstract class AddOnState extends Equatable {
  const AddOnState();
  @override
  List<Object?> get props => [];
}

class AddOnInitial extends AddOnState {}

class AddOnLoading extends AddOnState {}

class AddOnLoaded extends AddOnState {
  final List<ServiceTitle> services;
  final List<bool> selectedServices;
  final double estimatedBudget;

  const AddOnLoaded({
    required this.services,
    required this.selectedServices,
    this.estimatedBudget = 0.0,
  });

  AddOnLoaded copyWith({
    List<ServiceTitle>? services,
    List<bool>? selectedServices,
    double? estimatedBudget,
  }) {
    return AddOnLoaded(
      services: services ?? this.services,
      selectedServices: selectedServices ?? this.selectedServices,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
    );
  }

  @override
  List<Object?> get props => [services, selectedServices, estimatedBudget];
}

class AddOnError extends AddOnState {
  final String message;
  const AddOnError(this.message);
  @override
  List<Object?> get props => [message];
}

class AddOnCubit extends Cubit<AddOnState> {
  final String serviceType;

  AddOnCubit({required this.serviceType}) : super(AddOnInitial());

  Future<void> fetchServices() async {
    emit(AddOnLoading());
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      String endpoint;
      if (serviceType == "Pharmacist") {
        endpoint = '${Const.URL_API}/service-titles?service_type=pharma';
      } else if (serviceType == "Radiologist") {
        endpoint = '${Const.URL_API}/service-titles?service_type=radiologist';
      } else {
        endpoint = '${Const.URL_API}/service-titles?service_type=nurse';
      }

      final response = await Dio().get(
        endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final services = (response.data as List)
          .map((json) => ServiceTitle.fromJson(json))
          .toList();

      emit(AddOnLoaded(
        services: services,
        selectedServices: List<bool>.generate(services.length, (_) => false),
        estimatedBudget: 0.0,
      ));
    } catch (e) {
      log('Error fetching service titles: $e');
      emit(const AddOnError('Failed to fetch services. Pull to try again.'));
    }
  }

  void toggleServiceSelection(int index) {
    if (state is AddOnLoaded) {
      final currentState = state as AddOnLoaded;

      final newSelectedServices =
          List<bool>.from(currentState.selectedServices);
      newSelectedServices[index] = !newSelectedServices[index];

      double budget = 0.0;
      for (int i = 0; i < newSelectedServices.length; i++) {
        if (newSelectedServices[i]) {
          budget += currentState.services[i].price;
        }
      }

      emit(currentState.copyWith(
        selectedServices: newSelectedServices,
        estimatedBudget: budget,
      ));
    }
  }
}

class AddOn extends StatelessWidget {
  final Issue issue;
  final String serviceType;

  const AddOn({super.key, required this.issue, required this.serviceType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddOnCubit(serviceType: serviceType)..fetchServices(),
      child: _AddOnView(issue: issue, serviceType: serviceType),
    );
  }
}

class _AddOnView extends StatelessWidget {
  final Issue issue;
  final String serviceType;

  const _AddOnView({required this.issue, required this.serviceType});

  void _submitData(BuildContext context) {
    final state = context.read<AddOnCubit>().state;

    if (state is AddOnLoaded) {
      final String selectedAddOns = state.selectedServices
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) => state.services[entry.key].title)
          .join(', ');

      final updatedIssue = issue.copyWith(
        addOn: selectedAddOns,
        estimatedBudget: state.estimatedBudget,
      );

      context.read<PersonalCubit>().updateIssue(updatedIssue);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(
            serviceType: serviceType,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          serviceType == "Pharmacist"
              ? 'Pharmacist Add-On Services'
              : serviceType == "Radiologist"
                  ? 'Radiologist Add-On Services'
                  : 'Nursing Add-On Services',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<AddOnCubit, AddOnState>(
        builder: (context, state) {
          if (state is AddOnInitial || state is AddOnLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AddOnError) {
            return RefreshIndicator(
              onRefresh: () => context.read<AddOnCubit>().fetchServices(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Center(child: Text(state.message)),
                  ),
                ],
              ),
            );
          }

          if (state is AddOnLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: state.services.isEmpty
                        ? RefreshIndicator(
                            onRefresh: () =>
                                context.read<AddOnCubit>().fetchServices(),
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: const Center(
                                      child: Text('No services available')),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: state.services.length,
                            itemBuilder: (context, i) {
                              final service = state.services[i];
                              return Card(
                                child: ListTile(
                                  leading: Checkbox(
                                    value: state.selectedServices[i],
                                    onChanged: (bool? value) {
                                      context
                                          .read<AddOnCubit>()
                                          .toggleServiceSelection(i);
                                    },
                                    activeColor: const Color(0xFF35C5CF),
                                  ),
                                  title: Text(
                                    service.title,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '\$${service.price}',
                                    style: const TextStyle(
                                      color: Color(0xFF35C5CF),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: const Icon(
                                      Icons.info_outline_rounded,
                                      color: Colors.grey),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Estimated Budget',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        // Read budget from state
                        '\$${state.estimatedBudget.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 352,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () => _submitData(context),
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
                  ),
                ],
              ),
            );
          }

          // Fallback
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
