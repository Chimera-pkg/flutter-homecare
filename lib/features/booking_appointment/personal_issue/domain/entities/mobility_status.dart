import 'package:collection/collection.dart';

enum MobilityStatus {
  bedbound(displayName: 'Bedbound'),
  wheelchairBound(displayName: 'Wheelchair Bound'),
  walkingAid(displayName: 'Walking Aid'),
  mobileWithoutAid(displayName: 'Mobile Without Aid');

  final String displayName;

  const MobilityStatus({required this.displayName});

  String get apiValue => name;

  static MobilityStatus? fromApiValue(String? value) {
    if (value == null) return null;
    return MobilityStatus.values.firstWhereOrNull((e) => e.apiValue == value);
  }
}
