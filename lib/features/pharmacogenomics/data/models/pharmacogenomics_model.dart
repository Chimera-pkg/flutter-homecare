import 'package:m2health/features/pharmacogenomics/domain/entities/pharmacogenomics.dart';

class PharmacogenomicsModel extends Pharmacogenomics {
  const PharmacogenomicsModel({
    super.id,
    super.userId,
    super.fullReportPath,
    super.createdAt,
    super.updatedAt,
    super.abcg2,
    super.cyp2c19,
    super.cyp2c9,
    super.cyp2d6,
    super.cyp3a5,
    super.cyp4f2,
    super.dpyd,
    super.hlaA,
    super.hlaB1502,
    super.hlaB5701,
    super.hlaB5801,
    super.nudt15,
    super.slco1b1,
    super.tpmt,
    super.ugt1a1,
    super.vkorc1,
  });

  factory PharmacogenomicsModel.fromJson(Map<String, dynamic> json) {
    print('[DEBUG] PharmacogenomicsModel.fromJson input: $json');
    return PharmacogenomicsModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()),
      fullReportPath: json['full_report_path']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      abcg2: json['abcg2']?.toString(),
      cyp2c19: json['cyp2c19']?.toString(),
      cyp2c9: json['cyp2c9']?.toString(),
      cyp2d6: json['cyp2d6']?.toString(),
      cyp3a5: json['cyp3a5']?.toString(),
      cyp4f2: json['cyp4f2']?.toString(),
      dpyd: json['dpyd']?.toString(),
      hlaA: json['hla-a']?.toString(),
      hlaB1502: json['hla-b-15-02']?.toString(),
      hlaB5701: json['hla-b-57-01']?.toString(),
      hlaB5801: json['hla-b-58-01']?.toString(),
      nudt15: json['nudt15']?.toString(),
      slco1b1: json['slco1b1']?.toString(),
      tpmt: json['tpmt']?.toString(),
      ugt1a1: json['ugt1a1']?.toString(),
      vkorc1: json['vkorc1']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      // 'full_report_path': fullReportPath, // handle file upload separately
      'created_at': createdAt,
      'updated_at': updatedAt,
      'abcg2': abcg2,
      'cyp2c19': cyp2c19,
      'cyp2c9': cyp2c9,
      'cyp2d6': cyp2d6,
      'cyp3a5': cyp3a5,
      'cyp4f2': cyp4f2,
      'dpyd': dpyd,
      'hla-a': hlaA,
      'hla-b-15-02': hlaB1502,
      'hla-b-57-01': hlaB5701,
      'hla-b-58-01': hlaB5801,
      'nudt15': nudt15,
      'slco1b1': slco1b1,
      'tpmt': tpmt,
      'ugt1a1': ugt1a1,
      'vkorc1': vkorc1,
    };
  }

  factory PharmacogenomicsModel.fromEntity(Pharmacogenomics entity) {
    return PharmacogenomicsModel(
      id: entity.id,
      userId: entity.userId,
      fullReportPath: entity.fullReportPath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      abcg2: entity.abcg2,
      cyp2c19: entity.cyp2c19,
      cyp2c9: entity.cyp2c9,
      cyp2d6: entity.cyp2d6,
      cyp3a5: entity.cyp3a5,
      cyp4f2: entity.cyp4f2,
      dpyd: entity.dpyd,
      hlaA: entity.hlaA,
      hlaB1502: entity.hlaB1502,
      hlaB5701: entity.hlaB5701,
      hlaB5801: entity.hlaB5801,
      nudt15: entity.nudt15,
      slco1b1: entity.slco1b1,
      tpmt: entity.tpmt,
      ugt1a1: entity.ugt1a1,
      vkorc1: entity.vkorc1,
    );
  }
}
