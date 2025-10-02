class PaymentMethod {
  final String id;
  final String type;
  final String displayName;
  final String iconUrl;

  final String? accountNumber;
  final String? expiryDate;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    required this.iconUrl,
    this.accountNumber,
    this.expiryDate,
  });
}
