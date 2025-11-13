class MarketingServicesResponse {
  Meta? meta;
  List<Data>? data;

  MarketingServicesResponse({this.meta, this.data});

  MarketingServicesResponse.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  int? firstPage;
  String? firstPageUrl;
  String? lastPageUrl;
  String? nextPageUrl;
  String? previousPageUrl;

  Meta({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.firstPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.previousPageUrl,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    perPage = json['per_page'] ?? 0;
    currentPage = json['current_page'] ?? 0;
    lastPage = json['last_page'] ?? 0;
    firstPage = json['first_page'] ?? 0;
    firstPageUrl = json['first_page_url'] ?? '';
    lastPageUrl = json['last_page_url'] ?? '';
    nextPageUrl = json['next_page_url'] ?? '';
    previousPageUrl = json['previous_page_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total ?? 0;
    data['per_page'] = perPage ?? 0;
    data['current_page'] = currentPage ?? 0;
    data['last_page'] = lastPage ?? 0;
    data['first_page'] = firstPage ?? 0;
    data['first_page_url'] = firstPageUrl ?? '';
    data['last_page_url'] = lastPageUrl ?? '';
    data['next_page_url'] = nextPageUrl ?? '';
    data['previous_page_url'] = previousPageUrl ?? '';
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? content;
  bool? isPublished;
  String? createdAt;
  String? updatedAt;
  Category? category;
  Country? country;
  String? image;

  Data({
    this.id,
    this.title,
    this.content,
    this.isPublished,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.country,
    this.image,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? '';
    content = json['content'] ?? '';
    isPublished = json['is_published'] ?? false;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    country = json['country'] != null ? Country.fromJson(json['country']) : null;
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? 0;
    data['title'] = title ?? '';
    data['content'] = content ?? '';
    data['is_published'] = isPublished ?? false;
    data['created_at'] = createdAt ?? '';
    data['updated_at'] = updatedAt ?? '';
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['image'] = image ?? '';
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;

  Category({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? 0;
    data['name'] = name ?? '';
    data['description'] = description ?? '';
    data['created_at'] = createdAt ?? '';
    data['updated_at'] = updatedAt ?? '';
    return data;
  }
}

class Country {
  int? id;
  String? name;
  String? iso;
  String? phoneCode;
  String? createdAt;
  String? updatedAt;

  Country({
    this.id,
    this.name,
    this.iso,
    this.phoneCode,
    this.createdAt,
    this.updatedAt,
  });

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    iso = json['iso'] ?? '';
    phoneCode = json['phone_code'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? 0;
    data['name'] = name ?? '';
    data['iso'] = iso ?? '';
    data['phone_code'] = phoneCode ?? '';
    data['created_at'] = createdAt ?? '';
    data['updated_at'] = updatedAt ?? '';
    return data;
  }
}
