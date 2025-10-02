import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/usecases/crud_pharmacogenomics.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/usecases/get_pharmacogenomics.dart';
import 'package:m2health/cubit/pharmacogenomics/presentation/bloc/pharmacogenomics_state.dart';

class PharmacogenomicsCubit extends Cubit<PharmacogenomicsState> {
  final GetPharmacogenomics getPharmacogenomics;
  final CreatePharmacogenomic createPharmacogenomic;
  final UpdatePharmacogenomic updatePharmacogenomic;
  final DeletePharmacogenomic deletePharmacogenomic;

  PharmacogenomicsCubit({
    required this.getPharmacogenomics,
    required this.createPharmacogenomic,
    required this.updatePharmacogenomic,
    required this.deletePharmacogenomic,
  }) : super(PharmacogenomicsInitial());

  Future<void> fetchPharmacogenomics() async {
    print('[DEBUG] Cubit: fetchPharmacogenomics() called');
    try {
      emit(PharmacogenomicsLoading());
      final result = await getPharmacogenomics();
      print(
          '[DEBUG] Cubit: fetchPharmacogenomics() result count: ${result.length}');
      emit(PharmacogenomicsLoaded(result));
    } catch (e, s) {
      print('[DEBUG] Cubit: fetchPharmacogenomics() error: $e');
      print('[DEBUG] Cubit: Stacktrace: $s');
      emit(PharmacogenomicsError(e.toString()));
    }
  }

  Future<void> create(
    String gene,
    String genotype,
    String phenotype,
    String medicationGuidance,
  ) async {
    try {
      await createPharmacogenomic(
        gene,
        genotype,
        phenotype,
        medicationGuidance,
      );
      fetchPharmacogenomics();
    } catch (e) {
      emit(PharmacogenomicsError(e.toString()));
    }
  }

  Future<void> update(
    int id,
    String gene,
    String genotype,
    String phenotype,
    String medicationGuidance,
  ) async {
    try {
      await updatePharmacogenomic(
        id,
        gene,
        genotype,
        phenotype,
        medicationGuidance,
      );
      fetchPharmacogenomics();
    } catch (e) {
      emit(PharmacogenomicsError(e.toString()));
    }
  }

  Future<void> delete(int id) async {
    try {
      await deletePharmacogenomic(id);
      fetchPharmacogenomics();
    } catch (e) {
      emit(PharmacogenomicsError(e.toString()));
    }
  }
}
