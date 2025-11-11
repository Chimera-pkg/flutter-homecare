class Favorite {
  final int id;
  final int userId;
  final int itemId;
  final String itemType;
  final bool highlighted;

  Favorite({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.highlighted,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      userId: json['user_id'],
      itemId: json['item_id'],
      itemType: json['item_type'],
      highlighted: json['highlighted'] == 1,
    );
  }
}
