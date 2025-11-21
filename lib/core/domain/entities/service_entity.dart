import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final int id;
  final String name;
  final double price;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, price];
}
