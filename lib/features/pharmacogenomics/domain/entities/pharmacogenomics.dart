import 'package:equatable/equatable.dart';

class Pharmacogenomics extends Equatable {
  final int? id;
  final int? userId;
  final String? fullReportPath;
  final String? createdAt;
  final String? updatedAt;

  final String? abcg2;
  final String? cyp2c19;
  final String? cyp2c9;
  final String? cyp2d6;
  final String? cyp3a5;
  final String? cyp4f2;
  final String? dpyd;
  final String? hlaA;
  final String? hlaB1502;
  final String? hlaB5701;
  final String? hlaB5801;
  final String? nudt15;
  final String? slco1b1;
  final String? tpmt;
  final String? ugt1a1;
  final String? vkorc1;

  const Pharmacogenomics({
    this.id,
    this.userId,
    this.fullReportPath,
    this.createdAt,
    this.updatedAt,
    this.abcg2,
    this.cyp2c19,
    this.cyp2c9,
    this.cyp2d6,
    this.cyp3a5,
    this.cyp4f2,
    this.dpyd,
    this.hlaA,
    this.hlaB1502,
    this.hlaB5701,
    this.hlaB5801,
    this.nudt15,
    this.slco1b1,
    this.tpmt,
    this.ugt1a1,
    this.vkorc1,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        fullReportPath,
        createdAt,
        updatedAt,
        abcg2,
        cyp2c19,
        cyp2c9,
        cyp2d6,
        cyp3a5,
        cyp4f2,
        dpyd,
        hlaA,
        hlaB1502,
        hlaB5701,
        hlaB5801,
        nudt15,
        slco1b1,
        tpmt,
        ugt1a1,
        vkorc1,
      ];
}
