// // lib/features/nursing/presentation/bloc/nursing_case/nursing_case_bloc.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:m2health/cubit/nursing/domain/repositories/nursing_repository.dart';

// class NursingCaseBloc extends Bloc<NursingCaseEvent, NursingCaseState> {
//   final NursingRepository repository;

//   NursingCaseBloc(this.repository) : super(NursingCaseInitial()) {
//     on<CreateNursingCase>(_onCreateNursingCase);
//     on<LoadNursingCases>(_onLoadNursingCases);
//     on<UpdateNursingCase>(_onUpdateNursingCase);
//   }

//   Future<void> _onCreateNursingCase(
//     CreateNursingCase event,
//     Emitter<NursingCaseState> emit,
//   ) async {
//     emit(NursingCaseLoading());
//     try {
//       final nursingCase = await repository.createCase(
//         title: event.title,
//         description: event.description,
//         mobilityStatus: event.mobilityStatus,
//         careType: event.careType,
//         medicalRequirements: event.medicalRequirements,
//         relatedHealthRecordId: event.relatedHealthRecordId,
//         images: event.images,
//       );
//       emit(NursingCaseCreated(nursingCase));
//     } catch (e) {
//       emit(NursingCaseError(e.toString()));
//     }
//   }

//   Future<void> _onLoadNursingCases(
//     LoadNursingCases event,
//     Emitter<NursingCaseState> emit,
//   ) async {
//     emit(NursingCaseLoading());
//     try {
//       final cases = await repository.getCases();
//       emit(NursingCasesLoaded(cases));
//     } catch (e) {
//       emit(NursingCaseError(e.toString()));
//     }
//   }
// }
