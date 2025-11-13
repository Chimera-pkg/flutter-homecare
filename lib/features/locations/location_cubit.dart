import 'dart:convert' as convert;

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  final String url = "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/countries%2Bstates%2Bcities.json";

  Future<void> getWorldData() async {
    try {
      emit(LocationLoading());
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        emit(LocationLoaded(countries: jsonResponse));
      } else {
        emit(LocationError('Failed to load data'));
      }
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  void selectCountry(String countryName) {
    final selectedCountry = state.countries.firstWhere((country) => country["name"] == countryName);
    emit(LocationCountrySelected(selectedCountry));
  }

  void selectState(String stateName) {
    final selectedState = state.selectedCountry["states"].firstWhere((state) => state["name"] == stateName);
    emit(LocationStateSelected(selectedState));
  }

  void selectCity(String cityName) {
    emit(LocationCitySelected(cityName));
  }
}
