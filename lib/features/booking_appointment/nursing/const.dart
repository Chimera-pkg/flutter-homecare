enum NurseServiceType {
  primaryNurse,
  specializedNurse;

  String get label {
    switch (this) {
      case NurseServiceType.primaryNurse:
        return 'Nurse';
      case NurseServiceType.specializedNurse:
        return 'Specialized Nurse';
    }
  }

  String get apiValue {
    switch (this) {
      case NurseServiceType.primaryNurse:
        return 'nursing';
      case NurseServiceType.specializedNurse:
        return 'specialized_nursing';
    }
  }

  @override
  String toString() => label;
}
