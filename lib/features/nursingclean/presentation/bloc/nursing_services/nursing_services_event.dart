import 'package:equatable/equatable.dart';

abstract class NursingServicesEvent extends Equatable {
  const NursingServicesEvent();

  @override
  List<Object> get props => [];
}

class GetNursingServicesEvent extends NursingServicesEvent {}
