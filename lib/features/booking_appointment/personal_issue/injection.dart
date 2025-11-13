import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m2health/features/booking_appointment/personal_issue/data/datasources/personal_issue_remote_datasource.dart';
import 'package:m2health/features/booking_appointment/personal_issue/data/repositories/personal_issue_repository_impl.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/repositories/personal_issue_repository.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/create_personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/delete_personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/get_personal_issues.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/usecases/update_personal_issue.dart';

void initPersonalIssueModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => CreatePersonalIssue(sl()));
  sl.registerLazySingleton(() => DeletePersonalIssue(sl()));
  sl.registerLazySingleton(() => GetPersonalIssues(sl()));
  sl.registerLazySingleton(() => UpdatePersonalIssue(sl()));

  // Repository
  sl.registerLazySingleton<PersonalIssueRepository>(
    () => PersonalIssueRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PersonalIssueRemoteDataSource>(
    () => PersonalIssueRemoteDataSourceImpl(
      dio: sl<Dio>(),
    ),
  );
}
