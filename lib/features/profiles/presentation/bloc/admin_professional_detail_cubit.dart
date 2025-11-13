import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/profiles/data/datasources/profile_remote_datasource.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';

// --- STATE ---
abstract class AdminProfessionalDetailState extends Equatable {
  const AdminProfessionalDetailState();
  @override
  List<Object> get props => [];
}

class AdminProDetailInitial extends AdminProfessionalDetailState {}

class AdminProDetailLoading extends AdminProfessionalDetailState {}

class AdminProDetailLoaded extends AdminProfessionalDetailState {
  final ProfessionalProfile profile;
  const AdminProDetailLoaded(this.profile);
  @override
  List<Object> get props => [profile];
}

class AdminProDetailVerified extends AdminProfessionalDetailState {
  final ProfessionalProfile profile;
  const AdminProDetailVerified(this.profile);
  @override
  List<Object> get props => [profile];
}

class AdminProDetailError extends AdminProfessionalDetailState {
  final String message;
  const AdminProDetailError(this.message);
  @override
  List<Object> get props => [message];
}

// --- CUBIT ---
class AdminProfessionalDetailCubit extends Cubit<AdminProfessionalDetailState> {
  final ProfileRemoteDatasource remoteDatasource;

  AdminProfessionalDetailCubit(this.remoteDatasource)
      : super(AdminProDetailInitial());

  Future<void> loadDetail(int id, String role) async {
    try {
      emit(AdminProDetailLoading());
      final profile =
          await remoteDatasource.getAdminProfessionalDetail(id, role);
      emit(AdminProDetailLoaded(profile));
    } catch (e) {
      emit(AdminProDetailError(e.toString()));
    }
  }

  Future<void> verifyProfessional(int id, String role) async {
    final currentState = state;
    if (currentState is AdminProDetailLoaded) {
      try {
        // Show loading state (optional, or handle in UI via flag)
        // emit(AdminProDetailLoading());

        await remoteDatasource.verifyProfessional(id, role);

        // Refresh data to get updated status/timestamps
        final updatedProfile =
            await remoteDatasource.getAdminProfessionalDetail(id, role);
        emit(AdminProDetailVerified(updatedProfile));
      } catch (e) {
        emit(AdminProDetailError(e.toString()));
        // Re-emit loaded state to restore UI if needed
        emit(AdminProDetailLoaded(currentState.profile));
      }
    }
  }

  Future<void> revokeProfessional(int id, String role) async {
    final currentState = state;
    if (currentState is AdminProDetailLoaded) {
      try {
        // Call API
        await remoteDatasource.revokeVerification(id, role);

        // Refresh data to get updated status
        final updatedProfile =
            await remoteDatasource.getAdminProfessionalDetail(id, role);

        // Reuse Verified state or create a new one if distinct UI behavior is needed
        // For simplicity, we treat it as a status update
        emit(AdminProDetailVerified(updatedProfile));
      } catch (e) {
        emit(AdminProDetailError(e.toString()));
        emit(AdminProDetailLoaded(currentState.profile));
      }
    }
  }
}
