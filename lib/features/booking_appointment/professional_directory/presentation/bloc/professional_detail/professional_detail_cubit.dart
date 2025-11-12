import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/usecases/get_professional_detail.dart';
import 'package:m2health/features/booking_appointment/professional_directory/presentation/bloc/professional_detail/professional_detail_state.dart';

class ProfessionalDetailCubit extends Cubit<ProfessionalDetailState> {
  final GetProfessionalDetail getProfessionalDetail;

  ProfessionalDetailCubit({required this.getProfessionalDetail})
      : super(ProfessionalDetailInitial());

  Future<void> fetchProfessionalDetail(String serviceType, int id) async {
    emit(ProfessionalDetailLoading());
    try {
      final professional = await getProfessionalDetail(serviceType, id);
      emit(ProfessionalDetailLoaded(professional));
    } catch (e) {
      emit(ProfessionalDetailError(e.toString()));
    }
  }
}
