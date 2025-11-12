import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';

enum AddOnServiceStateStatus {
  initial,
  loading,
  loaded,
  error,
}

final class AddOnServiceState {
  final AddOnServiceStateStatus status;
  final List<AddOnService> addOnServices;
  final List<AddOnService> selectedAddOnServices;
  final String? errorMessage;

  double get estimatedBudget =>
      selectedAddOnServices.fold(0.0, (sum, service) => sum + service.price);

  const AddOnServiceState._({
    required this.status,
    this.addOnServices = const [],
    this.selectedAddOnServices = const [],
    this.errorMessage,
  });

  factory AddOnServiceState.initial() {
    return const AddOnServiceState._(status: AddOnServiceStateStatus.initial);
  }

  factory AddOnServiceState.loading() {
    return const AddOnServiceState._(status: AddOnServiceStateStatus.loading);
  }

  factory AddOnServiceState.loaded(List<AddOnService> addOnServices) {
    return AddOnServiceState._(
      status: AddOnServiceStateStatus.loaded,
      addOnServices: addOnServices,
    );
  }

  factory AddOnServiceState.error(String message) {
    return AddOnServiceState._(
      status: AddOnServiceStateStatus.error,
      errorMessage: message,
    );
  }

  AddOnServiceState copyWith({
    AddOnServiceStateStatus? status,
    List<AddOnService>? addOnServices,
    List<AddOnService>? selectedAddOnServices,
    String? errorMessage,
  }) {
    return AddOnServiceState._(
      status: status ?? this.status,
      addOnServices: addOnServices ?? this.addOnServices,
      selectedAddOnServices:
          selectedAddOnServices ?? this.selectedAddOnServices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
