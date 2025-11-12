import 'package:equatable/equatable.dart';

class AddOnService extends Equatable {
  final int? id;
  final String name;
  final double price;
  final String serviceType;

  const AddOnService({
    required this.id,
    required this.name,
    required this.price,
    required this.serviceType,
  });

  @override
  List<Object?> get props => [id, name, price, serviceType];
}
