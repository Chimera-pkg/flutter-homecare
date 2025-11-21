import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/repositories/add_on_service_repository.dart';
import 'package:m2health/features/profiles/data/datasources/profile_remote_datasource.dart';

// --- STATE ---
abstract class ManageServicesState extends Equatable {
  @override
  List<Object> get props => [];
}

class ManageServicesInitial extends ManageServicesState {}

class ManageServicesLoading extends ManageServicesState {}

class ManageServicesLoaded extends ManageServicesState {
  final List<AddOnService> allServices;
  final List<AddOnService> selectedServices;
  ManageServicesLoaded(this.allServices, this.selectedServices);
  @override
  List<Object> get props => [allServices, selectedServices];
}

class ManageServicesSaving extends ManageServicesState {}

class ManageServicesSuccess extends ManageServicesState {}

class ManageServicesError extends ManageServicesState {
  final String message;
  ManageServicesError(this.message);
}

// --- CUBIT ---
class ManageServicesCubit extends Cubit<ManageServicesState> {
  final ProfileRemoteDatasource profileRemoteDatasource;
  final AddOnServiceRepository addOnRepository;
  final String role;

  ManageServicesCubit({
    required this.profileRemoteDatasource,
    required this.addOnRepository,
    required this.role,
  }) : super(ManageServicesInitial());

  Future<void> loadServices(List<AddOnService> currentServices) async {
    emit(ManageServicesLoading());

    try {
      List<AddOnService> allAvailableServices = [];

      if (role == 'nurse') {
        // Fetch Primary Nursing
        final primaryResult = await addOnRepository.getAddOnServices('nursing');
        primaryResult.fold((l) => throw Exception(l.message),
            (r) => allAvailableServices.addAll(r));

        // Fetch Specialized Nursing
        final specializedResult =
            await addOnRepository.getAddOnServices('specialized_nursing');
        specializedResult.fold((l) => throw Exception(l.message),
            (r) => allAvailableServices.addAll(r));
      } else {
        // For Pharmacist/Radiologist
        String serviceType = role;
        if (role == 'pharmacist') serviceType = 'pharmacy';
        if (role == 'radiologist') serviceType = 'radiology';

        final result = await addOnRepository.getAddOnServices(serviceType);
        result.fold((failure) => throw Exception(failure.message),
            (services) => allAvailableServices = services);
      }

      emit(ManageServicesLoaded(allAvailableServices, currentServices));
    } catch (e) {
      log('Error loading services: $e');
      emit(ManageServicesError(e.toString()));
    }
  }

  void toggleService(AddOnService service) {
    if (state is ManageServicesLoaded) {
      final currentState = state as ManageServicesLoaded;
      final currentSelected =
          List<AddOnService>.from(currentState.selectedServices);

      // Check by ID
      if (currentSelected.any((s) => s.id == service.id)) {
        currentSelected.removeWhere((s) => s.id == service.id);
      } else {
        currentSelected.add(service);
      }

      emit(ManageServicesLoaded(currentState.allServices, currentSelected));
    }
  }

  void toggleCategoryServices(
      List<AddOnService> categoryServices, bool select) {
    if (state is ManageServicesLoaded) {
      final currentState = state as ManageServicesLoaded;
      final currentSelected =
          List<AddOnService>.from(currentState.selectedServices);

      if (select) {
        // Add services that are not already selected
        for (var service in categoryServices) {
          if (!currentSelected.any((s) => s.id == service.id)) {
            currentSelected.add(service);
          }
        }
      } else {
        // Remove services present in this category
        final idsToRemove = categoryServices.map((s) => s.id).toSet();
        currentSelected.removeWhere((s) => idsToRemove.contains(s.id));
      }

      emit(ManageServicesLoaded(currentState.allServices, currentSelected));
    }
  }

  Future<void> saveServices() async {
    if (state is ManageServicesLoaded) {
      final currentState = state as ManageServicesLoaded;
      emit(ManageServicesSaving());

      try {
        final ids = currentState.selectedServices.map((e) => e.id).toList();
        await profileRemoteDatasource.updateProvidedServices(role, ids);
        emit(ManageServicesSuccess());
      } catch (e) {
        emit(ManageServicesError(e.toString()));
        emit(ManageServicesLoaded(
            currentState.allServices, currentState.selectedServices));
      }
    }
  }
}
