import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/usecases/get_add_on_services.dart';
import 'package:m2health/features/booking_appointment/add_on_services/presentation/bloc/add_on_service_state.dart';

class AddOnServiceCubit extends Cubit<AddOnServiceState> {
  final GetAddOnServices getAddOnServices;

  AddOnServiceCubit(
    this.getAddOnServices, {
    List<AddOnService> initialSelectedServices = const [],
  }) : super(AddOnServiceState.initial(
          selectedServices: initialSelectedServices,
        ));

  Future<void> loadAddOnServices(String serviceType) async {
    emit(state.copyWith(status: AddOnServiceStateStatus.loading));
    final result = await getAddOnServices(serviceType);
    result.fold(
      (failure) {
        log('Error loading add-on services: ${failure.toString()}',
            name: 'AddOnServiceCubit');
        emit(AddOnServiceState.error('Failed to load add-on services'));
      },
      (addOnServices) {
        emit(state.copyWith(
          status: AddOnServiceStateStatus.loaded,
          addOnServices: addOnServices,
        ));
      },
    );
  }

  Future<void> toggleAddOnServiceSelection(AddOnService service) async {
    final currentState = state;
    if (currentState.status != AddOnServiceStateStatus.loaded) return;

    final selectedServices =
        List<AddOnService>.from(currentState.selectedAddOnServices);
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }

    emit(
      currentState.copyWith(selectedAddOnServices: selectedServices),
    );
  }
}
