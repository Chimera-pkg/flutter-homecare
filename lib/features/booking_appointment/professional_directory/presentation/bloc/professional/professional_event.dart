import 'package:equatable/equatable.dart';

abstract class ProfessionalEvent extends Equatable {
  const ProfessionalEvent();

  @override
  List<Object> get props => [];
}

class GetProfessionalsEvent extends ProfessionalEvent {
  final String serviceType;

  const GetProfessionalsEvent(this.serviceType);

  @override
  List<Object> get props => [serviceType];
}

class ToggleFavoriteEvent extends ProfessionalEvent {
  final int professionalId;
  final bool isFavorite;

  const ToggleFavoriteEvent(this.professionalId, this.isFavorite);

  @override
  List<Object> get props => [professionalId, isFavorite];
}
