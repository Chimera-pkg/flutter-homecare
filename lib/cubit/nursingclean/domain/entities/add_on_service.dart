import 'package:equatable/equatable.dart';

class AddOnService extends Equatable {
  final int? id;
  final String name;
  final double price;
  final String? description;

  const AddOnService({
    this.id,
    required this.name,
    required this.price,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description, price];
}
