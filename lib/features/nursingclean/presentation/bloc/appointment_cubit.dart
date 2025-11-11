// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:m2health/models/appointment.dart';
// import 'package:m2health/const.dart';
// import 'package:dio/dio.dart';
// import 'package:m2health/utils.dart';
// import 'package:m2health/services/appointment_service.dart';

// part 'appointment_state.dart';

// class AppointmentCubit extends Cubit<AppointmentState> {
//   final Dio _dio;
//   late final AppointmentService _appointmentService;

//   AppointmentCubit(this._dio) : super(AppointmentInitial()) {
//     _appointmentService = AppointmentService(_dio);
//   }
//   Future<void> fetchAppointments() async {
//     try {
//       emit(AppointmentLoading());

//       final appointments = await _appointmentService.fetchPatientAppointments();
//       emit(AppointmentLoaded(appointments));
//     } catch (e) {
//       print('Error in fetchAppointments: $e');
//       emit(AppointmentError(e.toString()));
//     }
//   }

//   Future<void> deleteAppointment(int appointmentId) async {
//     try {
//       await _appointmentService.deleteAppointment(appointmentId);
//       fetchAppointments(); // Refresh the list of appointments
//     } catch (e) {
//       emit(AppointmentError(e.toString()));
//     }
//   }

//   Future<void> cancelAppointment(int appointmentId) async {
//     try {
//       await _appointmentService.updateAppointmentStatus(
//           appointmentId, 'Cancelled');

//       if (state is AppointmentLoaded) {
//         final currentState = state as AppointmentLoaded;
//         final updatedAppointments =
//             currentState.appointments.map((appointment) {
//           if (appointment.id == appointmentId) {
//             return appointment.copyWith(status: 'Cancelled');
//           }
//           return appointment;
//         }).toList();

//         emit(AppointmentLoaded(updatedAppointments));
//       }
//     } catch (e) {
//       emit(AppointmentError(e.toString()));
//     }
//   }
// }
