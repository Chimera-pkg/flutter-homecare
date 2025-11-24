import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/personal_issue/data/datasources/personal_issue_remote_datasource.dart';
import 'package:m2health/features/booking_appointment/personal_issue/data/models/personal_issue_model.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/repositories/personal_issue_repository.dart';

class PersonalIssueRepositoryImpl implements PersonalIssueRepository {
  final PersonalIssueRemoteDataSource remoteDataSource;

  PersonalIssueRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PersonalIssue>>> getPersonalIssues(String serviceType) async {
    try {
      final issues = await remoteDataSource.getPersonalIssues(serviceType);
      return Right(issues);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PersonalIssue>> createPersonalIssue(PersonalIssue issue) async {
    try {
      final model = PersonalIssueModel.fromEntity(issue);
      log('Creating Personal Issue: ${model.toJson()}',
          name: 'PersonalIssueRepositoryImpl');
      final newIssue = await remoteDataSource.createPersonalIssue(model);
      return Right(newIssue);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePersonalIssue(
      int id, PersonalIssue issue) async {
    try {
      final model = PersonalIssueModel.fromEntity(issue);
      await remoteDataSource.updatePersonalIssue(id, model);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePersonalIssue(int issueId) async {
    try {
      await remoteDataSource.deletePersonalIssue(issueId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
