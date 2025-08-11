import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_professionals.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/toggle_favorite.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/professional/professional_event.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/professional/professional_state.dart';

class ProfessionalBloc extends Bloc<ProfessionalEvent, ProfessionalState> {
  final GetProfessionals getProfessionals;
  final ToggleFavorite toggleFavorite;

  ProfessionalBloc({
    required this.getProfessionals,
    required this.toggleFavorite,
  }) : super(ProfessionalInitial()) {
    on<GetProfessionalsEvent>((event, emit) async {
      emit(ProfessionalLoading());
      try {
        final professionals = await getProfessionals(event.serviceType);
        emit(ProfessionalLoaded(professionals));
      } catch (e) {
        emit(ProfessionalError(e.toString()));
      }
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      // Here you would typically update the favorite status and then reload the list
      // For now, we will just placeholder the call
      await toggleFavorite(event.professionalId, event.isFavorite);
    });
  }
}
