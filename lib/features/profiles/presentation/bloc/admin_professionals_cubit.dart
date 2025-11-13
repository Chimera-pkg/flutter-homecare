import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/profiles/data/datasources/profile_remote_datasource.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';

// --- STATE ---
abstract class AdminProfessionalsState extends Equatable {
  const AdminProfessionalsState();
  @override
  List<Object> get props => [];
}

class AdminProsInitial extends AdminProfessionalsState {}

class AdminProsLoading extends AdminProfessionalsState {}

class AdminProsLoaded extends AdminProfessionalsState {
  final List<ProfessionalProfile> professionals;
  const AdminProsLoaded(this.professionals);
  @override
  List<Object> get props => [professionals];
}

class AdminProsActionSuccess extends AdminProfessionalsState {
  final String message;
  const AdminProsActionSuccess(this.message);
}

class AdminProsError extends AdminProfessionalsState {
  final String message;
  const AdminProsError(this.message);
  @override
  List<Object> get props => [message];
}

// --- CUBIT ---
class AdminProfessionalsCubit extends Cubit<AdminProfessionalsState> {
  final ProfileRemoteDatasource remoteDatasource;

  AdminProfessionalsCubit(this.remoteDatasource) : super(AdminProsInitial());

  Future<void> fetchProfessionals(String role, String status) async {
    try {
      emit(AdminProsLoading());
      final result = await remoteDatasource.getAdminProfessionals(role, status);
      emit(AdminProsLoaded(result));
    } catch (e) {
      emit(AdminProsError(e.toString()));
    }
  }

  Future<void> verifyProfessional(int id, String role) async {
    try {
      // Don't emit loading here to prevent full page reload,
      // usually handled by UI loading indicator on button
      await remoteDatasource.verifyProfessional(id, role);
      emit(const AdminProsActionSuccess("Professional verified successfully"));
    } catch (e) {
      emit(AdminProsError(e.toString()));
    }
  }
}
