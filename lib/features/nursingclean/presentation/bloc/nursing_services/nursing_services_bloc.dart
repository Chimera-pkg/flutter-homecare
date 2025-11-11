import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/nursingclean/domain/usecases/get_nursing_services.dart';
import 'package:m2health/features/nursingclean/presentation/bloc/nursing_services/nursing_services_event.dart';
import 'package:m2health/features/nursingclean/presentation/bloc/nursing_services/nursing_services_state.dart';

class NursingServicesBloc
    extends Bloc<NursingServicesEvent, NursingServicesState> {
  final GetNursingServices getNursingServices;

  NursingServicesBloc({
    required this.getNursingServices,
  }) : super(NursingServicesInitial()) {
    on<GetNursingServicesEvent>((event, emit) async {
      emit(NursingServicesLoading());
      final nursingServices = await getNursingServices();
      emit(NursingServicesLoaded(nursingServices));
    });
  }
}
