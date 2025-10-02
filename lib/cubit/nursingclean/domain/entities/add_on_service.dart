import 'package:equatable/equatable.dart';

class AddOnService extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final double price;

  const AddOnService({
    this.id,
    required this.name,
    this.description,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, description, price];
}
