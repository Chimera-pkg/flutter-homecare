import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/pharmacist/presentation/bloc/pharmacist_case_cubit.dart';
import 'package:m2health/features/pharmacist/presentation/bloc/pharmacist_case_state.dart';
import 'package:dio/dio.dart';
import 'package:m2health/features/pharmacist/data/datasources/pharmacist_remote_datasource.dart';
import 'package:m2health/features/pharmacist/data/datasources/pharmacist_remote_datasource_impl.dart';
import 'package:m2health/features/pharmacist/data/repositories/pharmacist_repository_impl.dart';
import 'package:m2health/features/pharmacist/domain/repositories/pharmacist_repository.dart';
import 'package:m2health/features/pharmacist/domain/usecases/get_pharmacist_cases.dart';

class PharmacistPersonalCasesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // This is a simplified DI. In a real app, use get_it or similar.
        final Dio dio = Dio();
        final PharmacistRemoteDataSource remoteDataSource =
            PharmacistRemoteDataSourceImpl(dio: dio);
        final PharmacistRepository repository =
            PharmacistRepositoryImpl(remoteDataSource: remoteDataSource);
        final GetPharmacistCases getPharmacistCases =
            GetPharmacistCases(repository);
        return PharmacistCaseCubit(getPharmacistCases: getPharmacistCases)
          ..fetchPharmacistCases();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pharmacist Personal Cases'),
        ),
        body: BlocBuilder<PharmacistCaseCubit, PharmacistCaseState>(
          builder: (context, state) {
            if (state is PharmacistCaseLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PharmacistCaseLoaded) {
              if (state.cases.isEmpty) {
                return Center(child: Text('No pharmacist cases found.'));
              }
              return ListView.builder(
                itemCount: state.cases.length,
                itemBuilder: (context, index) {
                  final pharmacistCase = state.cases[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(pharmacistCase.title),
                      subtitle: Text(pharmacistCase.description),
                    ),
                  );
                },
              );
            } else if (state is PharmacistCaseError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No data.'));
          },
        ),
      ),
    );
  }
}
