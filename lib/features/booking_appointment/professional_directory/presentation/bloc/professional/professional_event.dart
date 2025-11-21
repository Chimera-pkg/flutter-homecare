import 'package:equatable/equatable.dart';

abstract class ProfessionalEvent extends Equatable {
  const ProfessionalEvent();

  @override
  List<Object> get props => [];
}

class GetProfessionalsEvent extends ProfessionalEvent {
  final String role;
  final String? name;
  final List<int>? serviceIds;
  final bool? isHomeScreeningAuthorized;

  const GetProfessionalsEvent(this.role,
      {this.name, this.serviceIds, this.isHomeScreeningAuthorized});

  @override
  List<Object> get props =>
      [role, name ?? '', serviceIds ?? [], isHomeScreeningAuthorized ?? false];
}

class ToggleFavoriteEvent extends ProfessionalEvent {
  final int professionalId;
  final bool isFavorite;

  const ToggleFavoriteEvent(this.professionalId, this.isFavorite);

  @override
  List<Object> get props => [professionalId, isFavorite];
}
