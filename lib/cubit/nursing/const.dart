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
        return 'nurse';
      case NurseServiceType.specializedNurse:
        return 'specialized_nurse';
    }
  }

  @override
  String toString() => label;
}
