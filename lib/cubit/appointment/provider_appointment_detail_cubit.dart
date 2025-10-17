import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:m2health/models/provider_appointment.dart';
import 'package:meta/meta.dart';

part 'provider_appointment_detail_state.dart';

class ProviderAppointmentDetailCubit
    extends Cubit<ProviderAppointmentDetailState> {
  ProviderAppointmentDetailCubit() : super(ProviderAppointmentDetailInitial());

  Future<void> fetchProviderAppointmentById(int appointmentId) async {
    emit(ProviderAppointmentDetailLoading());
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      final appointment = ProviderAppointment(
        id: appointmentId,
        userId: 2,
        type: 'nurse',
        status: 'Pending',
        date: '2023-08-17',
        hour: '11:00 AM - 11:40 AM',
        summary: '',
        payTotal: 150,
        providerType: 'nurse',
        patientData: {
          'username': 'Prajogo Pangestu',
          'full_name': 'Anna Bella',
          'age': 27,
          'gender': 'Female',
          'weight': 50,
          'height': 155,
          'address': 'South Pacific Road IV 35, Building F, Singapore',
          'avatar': 'https://i.imgur.com/K0VUcFB.jpeg'
        },
        profileServiceData: {},
        personalCase: {
          'services': 'Specialized Nursing Services',
          'description':
              "I have any of these:\n- feeling generally unwell\n- not able to get out of bed\n- a change in your temperature\n- 37.5°C or higher or below 36°C\n- flu-like symptoms\n- feeling cold and shivery, headaches, and aching muscles\n- coughing up green phlegm\n- a sore throat or sore mouth\n- a throbbing, painful tooth\n- pain having a wee, going more often or cloudy or foul smelling wee\n- diarrhoea\n- 4 or more loose, watery bowel movements in 24 hours\n- skin changes\n- redness, feeling hot, swelling or pain\n- a fast heartbeat\n- feeling dizzy or faint\n- being sick (vomiting)\n- a headache\n- pain, redness, discharge, swelling or heat at the site of a wound or intravenous line such as a central line or PICC line\n- pain anywhere in your body that was not there before your treatment",
          'images': [
            'https://i.imgur.com/pwusx4j.jpeg',
            'https://i.imgur.com/NjnmwMB.png'
          ]
        },
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      emit(ProviderAppointmentDetailLoaded(appointment));
    } catch (e) {
      log('Error fetching appointment detail: $e',
          name: 'ProviderAppointmentDetailCubit');
      emit(ProviderAppointmentDetailError('Error: $e'));
    }
  }
}
