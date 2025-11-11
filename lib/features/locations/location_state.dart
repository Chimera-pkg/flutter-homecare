part of 'location_cubit.dart';

@immutable
abstract class LocationState {
  final List<dynamic> countries;
  final Map<String, dynamic> selectedCountry;
  final Map<String, dynamic> selectedState;
  final String selectedCity;

  const LocationState({
    this.countries = const [],
    this.selectedCountry = const {},
    this.selectedState = const {},
    this.selectedCity = '',
  });
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  const LocationLoaded({required List<dynamic> countries}) : super(countries: countries);
}

class LocationCountrySelected extends LocationState {
  const LocationCountrySelected(Map<String, dynamic> selectedCountry)
      : super(selectedCountry: selectedCountry);
}

class LocationStateSelected extends LocationState {
  const LocationStateSelected(Map<String, dynamic> selectedState)
      : super(selectedState: selectedState);
}

class LocationCitySelected extends LocationState {
  const LocationCitySelected(String selectedCity) : super(selectedCity: selectedCity);
}

class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);
}
