// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_personal_case/nursing_personal_case_cubit.dart';
// import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_personal_case/nursing_personal_case_state.dart';
// import 'package:dio/dio.dart';
// import 'package:m2health/cubit/nursingclean/data/datasources/nursing_remote_datasource.dart';
// import 'package:m2health/cubit/nursingclean/data/repositories/nursing_repository_impl.dart';
// import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';
// import 'package:m2health/cubit/nursingclean/presentation/pages/nursing_personal_case_detail_page.dart';

// class NursingPersonalCasesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) {
//         // This is a simplified DI. In a real app, use get_it or similar.
//         final Dio dio = Dio();
//         // Note: This is not ideal. You should reuse the existing remote data source if possible.
//         final NursingRemoteDataSource remoteDataSource =
//             NursingRemoteDataSourceImpl(dio: dio);
//         final NursingRepository repository =
//             NursingRepositoryImpl(remoteDataSource: remoteDataSource);
//         return NursingPersonalCaseCubit(nursingRepository: repository)
//           ..fetchNursingPersonalCases();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Nursing Personal Cases'),
//         ),
//         body: BlocBuilder<NursingPersonalCaseCubit, NursingPersonalCaseState>(
//           builder: (context, state) {
//             if (state is NursingPersonalCaseLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is NursingPersonalCaseLoaded) {
//               if (state.cases.isEmpty) {
//                 return Center(child: Text('No nursing cases found.'));
//               }
//               return ListView.builder(
//                 itemCount: state.cases.length,
//                 itemBuilder: (context, index) {
//                   final nursingCase = state.cases[index];
//                   return Card(
//                     margin: const EdgeInsets.all(8.0),
//                     child: ListTile(
//                       title: Text(nursingCase.title),
//                       subtitle: Text(nursingCase.description),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => NursingPersonalCaseDetailPage(
//                               nursingCase: nursingCase,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               );
//             } else if (state is NursingPersonalCaseError) {
//               return Center(child: Text(state.message));
//             }
//             return Center(child: Text('No data.'));
//           },
//         ),
//       ),
//     );
//   }
// }
