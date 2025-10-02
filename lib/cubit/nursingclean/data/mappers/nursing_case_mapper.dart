import 'package:m2health/cubit/nursingclean/data/models/nursing_personal_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/mobility_status.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_issue.dart';

class NursingCaseMapper {
  // Change a list of models from the API into a single domain entity
  NursingCase mapModelsToEntity(List<NursingPersonalCaseModel> models) {
    if (models.isEmpty) {
      // create a default empty NursingCase if no models are provided
      return const NursingCase(
        issues: [],
        addOnServices: [],
        estimatedBudget: 0.0,
      );
    }

    final List<NursingIssue> allIssues = models
        .map((model) => NursingIssue(
              title: model.title,
              description: model.description ?? '',
              images: model.images ?? [],
            ))
        .toList();

    final firstModel = models.first;

    final List<AddOnService> addOnServices = firstModel.addOn != null
        ? firstModel.addOn!
            .split(',')
            .map((e) => AddOnService(name: e.trim(), price: 0.0))
            .toList()
        : [];

    return NursingCase(
      appointmentId: firstModel.appointmentId,
      careType: firstModel.careType ?? '',
      issues: allIssues,
      mobilityStatus: MobilityStatus.fromApiValue(firstModel.mobilityStatus),
      relatedHealthRecordId: firstModel.relatedHealthRecordId,
      addOnServices: addOnServices,
      estimatedBudget: firstModel.estimatedBudget ?? 0.0,
    );
  }

  // Change a domain entity into a list of models for the API
  List<NursingPersonalCaseModel> mapEntityToModels(NursingCase entity) {
    return entity.issues.map((issue) {
      return NursingPersonalCaseModel(
        appointmentId: entity.appointmentId,
        title: issue.title,
        description: issue.description,
        mobilityStatus: entity.mobilityStatus?.apiValue,
        careType: entity.careType,
        addOn: entity.addOnServices.map((e) => e.name).join(', '),
        estimatedBudget: entity.estimatedBudget,
        relatedHealthRecordId: entity.relatedHealthRecordId,
        images: issue.images,
      );
    }).toList();
  }
}
