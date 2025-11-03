class Payment {
  final int id;
  final int userId;
  final int appointmentId;
  final String method;
  final String amount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.userId,
    required this.appointmentId,
    required this.method,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Payment instance from JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      userId: json['user_id'],
      appointmentId: json['appointment_id'],
      method: json['method'],
      amount: json['amount'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert a Payment instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'appointment_id': appointmentId,
      'method': method,
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
