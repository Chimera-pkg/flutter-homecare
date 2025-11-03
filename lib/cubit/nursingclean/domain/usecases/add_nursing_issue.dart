import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_issue.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';

class AddNursingIssue {
  final NursingRepository repository;

  AddNursingIssue(this.repository);

  Future<Either<Failure, NursingIssue>> call(NursingIssue issue, NursingCase currentCase) async {
    return await repository.addNursingIssue(issue, currentCase);
  }
}