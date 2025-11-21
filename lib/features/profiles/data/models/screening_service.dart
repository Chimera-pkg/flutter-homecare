class ScreeningServiceCategory {
  final int? id;
  final String name;
  final String? description;
  final bool isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ScreeningServiceItem> items;

  ScreeningServiceCategory({
    this.id,
    required this.name,
    this.description,
    required this.isPublished,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
  });

  factory ScreeningServiceCategory.fromJson(Map<String, dynamic> json) {
    return ScreeningServiceCategory(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      isPublished: json['is_published'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ScreeningServiceItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'is_published': isPublished,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  ScreeningServiceCategory copyWith({
    int? id,
    String? name,
    String? description,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ScreeningServiceItem>? items,
  }) {
    return ScreeningServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }
}

class ScreeningServiceItem {
  final int? id;
  final int? screeningServiceCategoryId;
  final String name;
  final String? description;
  final double price;
  final bool isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ScreeningServiceItem({
    this.id,
    this.screeningServiceCategoryId,
    required this.name,
    this.description,
    required this.price,
    required this.isPublished,
    this.createdAt,
    this.updatedAt,
  });

  factory ScreeningServiceItem.fromJson(Map<String, dynamic> json) {
    return ScreeningServiceItem(
      id: json['id'],
      screeningServiceCategoryId: json['screening_service_category_id'],
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      isPublished: json['is_published'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (screeningServiceCategoryId != null)
        'screening_service_category_id': screeningServiceCategoryId,
      'name': name,
      'description': description,
      'price': price,
      'is_published': isPublished,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  ScreeningServiceItem copyWith({
    int? id,
    int? screeningServiceCategoryId,
    String? name,
    String? description,
    double? price,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScreeningServiceItem(
      id: id ?? this.id,
      screeningServiceCategoryId:
          screeningServiceCategoryId ?? this.screeningServiceCategoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
