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
  final bool isHomeScreeningAuthorized;

  ManageServicesLoaded(
    this.allServices,
    this.selectedServices, {
    this.isHomeScreeningAuthorized = false,
  });

  @override
  List<Object> get props =>
      [allServices, selectedServices, isHomeScreeningAuthorized];
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

  Future<void> loadServices(List<AddOnService> currentServices,
      {bool isHomeScreeningAuthorized = false}) async {
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

      emit(ManageServicesLoaded(
        allAvailableServices,
        currentServices,
        isHomeScreeningAuthorized: isHomeScreeningAuthorized,
      ));
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

      if (currentSelected.any((s) => s.id == service.id)) {
        currentSelected.removeWhere((s) => s.id == service.id);
      } else {
        currentSelected.add(service);
      }

      emit(ManageServicesLoaded(
        currentState.allServices,
        currentSelected,
        isHomeScreeningAuthorized: currentState.isHomeScreeningAuthorized,
      ));
    }
  }

  void toggleCategoryServices(
      List<AddOnService> categoryServices, bool select) {
    if (state is ManageServicesLoaded) {
      final currentState = state as ManageServicesLoaded;
      final currentSelected =
          List<AddOnService>.from(currentState.selectedServices);

      if (select) {
        for (var service in categoryServices) {
          if (!currentSelected.any((s) => s.id == service.id)) {
            currentSelected.add(service);
          }
        }
      } else {
        final idsToRemove = categoryServices.map((s) => s.id).toSet();
        currentSelected.removeWhere((s) => idsToRemove.contains(s.id));
      }

      emit(ManageServicesLoaded(
        currentState.allServices,
        currentSelected,
        isHomeScreeningAuthorized: currentState.isHomeScreeningAuthorized,
      ));
    }
  }

  void toggleHomeScreeningAuthorization(bool value) {
    if (state is ManageServicesLoaded) {
      final currentState = state as ManageServicesLoaded;
      emit(ManageServicesLoaded(
        currentState.allServices,
        currentState.selectedServices,
        isHomeScreeningAuthorized: value,
      ));
    }
  }

  Future<void> saveServices() async {
    if (state is ManageServicesLoaded) {
      final currentState = state as ManageServicesLoaded;
      emit(ManageServicesSaving());

      try {
        final ids = currentState.selectedServices.map((e) => e.id).toList();
        await profileRemoteDatasource.updateProvidedServices(
          role,
          ids,
          isHomeScreeningAuthorized:
              role == 'nurse' ? currentState.isHomeScreeningAuthorized : null,
        );
        emit(ManageServicesSuccess());
      } catch (e) {
        emit(ManageServicesError(e.toString()));
        emit(ManageServicesLoaded(
          currentState.allServices,
          currentState.selectedServices,
          isHomeScreeningAuthorized: currentState.isHomeScreeningAuthorized,
        ));
      }
    }
  }
}
