// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';
// import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_personal_case/nursing_personal_case_state.dart';

// class NursingPersonalCaseCubit extends Cubit<NursingPersonalCaseState> {
//   final NursingRepository nursingRepository;

//   NursingPersonalCaseCubit({required this.nursingRepository})
//       : super(NursingPersonalCaseInitial());

//   Future<void> fetchNursingPersonalCases() async {
//     try {
//       emit(NursingPersonalCaseLoading());
//       final cases = await nursingRepository.getNursingCases();
//       emit(NursingPersonalCaseLoaded(cases));
//     } catch (e) {
//       emit(NursingPersonalCaseError(e.toString()));
//     }
//   }
// }
