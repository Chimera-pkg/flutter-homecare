import 'package:m2health/core/domain/entities/service_entity.dart';

class AddOnService extends ServiceEntity {
  final String serviceType;

  const AddOnService({
    required super.id,
    required super.name,
    required super.price,
    required this.serviceType,
  });

  @override
  List<Object?> get props => [id, name, price, serviceType];
}
