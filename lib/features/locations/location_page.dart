import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_cubit.dart';

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Multiple Dynamic Dependent Dropdown")),
      body: BlocProvider(
        create: (_) => LocationCubit()..getWorldData(),
        child: LocationView(),
      ),
    );
  }
}

class LocationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<LocationCubit, LocationState>(
            builder: (context, state) {
              if (state is LocationLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LocationLoaded) {
                return CountryDropdown(countries: state.countries);
              } else if (state is LocationError) {
                return Center(child: Text(state.message));
              } else if (state is LocationCountrySelected) {
                return Column(
                  children: [
                    CountryDropdown(countries: state.countries),
                    StateDropdown(states: state.selectedCountry["states"]),
                  ],
                );
              } else if (state is LocationStateSelected) {
                return Column(
                  children: [
                    CountryDropdown(countries: state.countries),
                    StateDropdown(states: state.selectedCountry["states"]),
                    CityDropdown(cities: state.selectedState["cities"]),
                  ],
                );
              } else if (state is LocationCitySelected) {
                return Column(
                  children: [
                    CountryDropdown(countries: state.countries),
                    StateDropdown(states: state.selectedCountry["states"]),
                    CityDropdown(cities: state.selectedState["cities"]),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

class CountryDropdown extends StatelessWidget {
  final List<dynamic> countries;

  CountryDropdown({required this.countries});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: DropdownButton<String>(
          underline: Container(),
          hint: Text("Select Country"),
          icon: const Icon(Icons.keyboard_arrow_down),
          isDense: true,
          isExpanded: true,
          items: countries.map((ctry) {
            return DropdownMenuItem<String>(
              value: ctry["name"],
              child: Text(ctry["name"]),
            );
          }).toList(),
          value: context.read<LocationCubit>().state.selectedCountry["name"],
          onChanged: (value) {
            context.read<LocationCubit>().selectCountry(value!);
          },
        ),
      ),
    );
  }
}

class StateDropdown extends StatelessWidget {
  final List<dynamic> states;

  StateDropdown({required this.states});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: DropdownButton<String>(
          underline: Container(),
          hint: Text("Select State"),
          icon: const Icon(Icons.keyboard_arrow_down),
          isDense: true,
          isExpanded: true,
          items: states.map((st) {
            return DropdownMenuItem<String>(
              value: st["name"],
              child: Text(st["name"]),
            );
          }).toList(),
          value: context.read<LocationCubit>().state.selectedState["name"],
          onChanged: (value) {
            context.read<LocationCubit>().selectState(value!);
          },
        ),
      ),
    );
  }
}

class CityDropdown extends StatelessWidget {
  final List<dynamic> cities;

  CityDropdown({required this.cities});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: DropdownButton<String>(
          underline: Container(),
          hint: Text("Select City"),
          icon: const Icon(Icons.keyboard_arrow_down),
          isDense: true,
          isExpanded: true,
          items: cities.map((ct) {
            return DropdownMenuItem<String>(
              value: ct["name"],
              child: Text(ct["name"]),
            );
          }).toList(),
          value: context.read<LocationCubit>().state.selectedCity,
          onChanged: (value) {
            context.read<LocationCubit>().selectCity(value!);
          },
        ),
      ),
    );
  }
}
